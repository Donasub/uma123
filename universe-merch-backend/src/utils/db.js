import pg from 'pg';
import dotenv from 'dotenv';

dotenv.config();

const { Pool } = pg;

// Determine database type
export const DB_TYPE = process.env.DB_TYPE || 'postgres'; // 'postgres' or 'sqlite'

// PostgreSQL setup
let pool = null;
if (DB_TYPE === 'postgres') {
  pool = new Pool({
    connectionString: process.env.DATABASE_URL,
    ssl: process.env.PGSSLMODE === 'require' ? { rejectUnauthorized: false } : false,
  });

  pool.on('error', (err) => {
    console.error('Unexpected error on idle client', err);
    process.exit(-1);
  });
}

// SQLite setup (loaded dynamically only when needed)
let sqliteDb = null;

async function initSQLite() {
  if (DB_TYPE === 'sqlite') {
    const sqlite3 = (await import('sqlite3')).default;
    const { open } = await import('sqlite');
    sqliteDb = await open({
      filename: process.env.DATABASE_URL || './database.sqlite',
      driver: sqlite3.Database,
    });

    // Enable foreign keys
    await sqliteDb.exec('PRAGMA foreign_keys = ON');

    return sqliteDb;
  }
}

// Helper converts Postgres-style numbered placeholders ($1, $2) to SQLite '?' placeholders
function toSqlitePlaceholders(sql) {
  return sql.replace(/\$\d+/g, '?');
}

// Strip PostgreSQL-only clauses that SQLite doesn't support
function sanitizeForSQLite(sql) {
  // Remove row-level locking (FOR UPDATE, FOR SHARE, etc.)
  sql = sql.replace(/\s+FOR\s+(UPDATE|SHARE|NO\s+KEY\s+UPDATE|KEY\s+SHARE)(\s+OF\s+\w+)?(\s+NOWAIT|\s+SKIP\s+LOCKED)?\s*/gi, ' ');
  // Remove ILIKE → LIKE (SQLite LIKE is already case-insensitive for ASCII)
  sql = sql.replace(/\bILIKE\b/gi, 'LIKE');
  return sql;
}

// Query function that works with both databases
export const query = async (text, params = []) => {
  if (DB_TYPE === 'postgres') {
    return pool.query(text, params);
  } else if (DB_TYPE === 'sqlite') {
    if (!sqliteDb) {
      await initSQLite();
    }

    let sql = text;
    sql = sanitizeForSQLite(sql);
    sql = sql.replace(/SERIAL PRIMARY KEY/gi, 'INTEGER PRIMARY KEY AUTOINCREMENT');
    sql = sql.replace(/uuid_generate_v4\(\)/gi, 'lower(hex(randomblob(4))) || \'-\' || lower(hex(randomblob(2))) || \'-4\' || substr(lower(hex(randomblob(2))),2) || \'-\' || substr(\'89ab\',abs(random()) % 4 + 1, 1) || substr(lower(hex(randomblob(2))),2) || \'-\' || lower(hex(randomblob(6)))');
    sql = sql.replace(/CURRENT_TIMESTAMP/gi, 'datetime(\'now\')');
    sql = sql.replace(/TEXT\[\]/gi, 'TEXT'); // Simple array handling

    const isSelect = sql.trim().toUpperCase().startsWith('SELECT') || sql.trim().toUpperCase().startsWith('WITH');
    const isInsertReturning = /RETURNING\s+.+$/i.test(sql) && sql.trim().toUpperCase().startsWith('INSERT');

    if (isInsertReturning) {
      const returningMatch = sql.match(/RETURNING\s+(.+)$/i);
      const returningCols = returningMatch ? returningMatch[1] : null;
      sql = sql.replace(/RETURNING\s+.+$/i, '');
      sql = toSqlitePlaceholders(sql);

      const result = await sqliteDb.run(sql, params);
      if (returningCols) {
        const row = await sqliteDb.get(`SELECT ${returningCols} FROM ${getTableName(sql)} WHERE rowid = ?`, result.lastID);
        return { rows: [row] };
      }
      return { rows: [] };
    }

    sql = toSqlitePlaceholders(sql);

    if (isSelect) {
      const rows = await sqliteDb.all(sql, params);
      return { rows };
    }

    // Support simple transaction statements
    const trimmed = sql.trim().toUpperCase();
    if (['BEGIN', 'BEGIN TRANSACTION', 'COMMIT', 'ROLLBACK'].includes(trimmed)) {
      await sqliteDb.exec(trimmed === 'BEGIN' ? 'BEGIN TRANSACTION' : trimmed);
      return { rows: [] };
    }

    const result = await sqliteDb.run(sql, params);
    return {
      rows: [],
      rowCount: result.changes,
      lastID: result.lastID,
    };
  }
};

// Get client for transactions (PostgreSQL style)
export const getClient = async () => {
  if (DB_TYPE === 'postgres') {
    return pool.connect();
  } else {
    if (!sqliteDb) {
      await initSQLite();
    }
    return {
      query: async (text, params = []) => {
        const sql = sanitizeForSQLite(text).trim().toUpperCase();
        if (sql === 'BEGIN') {
          await sqliteDb.exec('BEGIN TRANSACTION');
          return { rows: [] };
        }
        if (sql === 'COMMIT') {
          await sqliteDb.exec('COMMIT');
          return { rows: [] };
        }
        if (sql === 'ROLLBACK') {
          await sqliteDb.exec('ROLLBACK');
          return { rows: [] };
        }
        return query(text, params);
      },
      release: () => {},
    };
  }
};

// Helper function to get table name from INSERT statement
function getTableName(sql) {
  const match = sql.match(/INSERT INTO\s+(\w+)/i);
  return match ? match[1] : '';
}

export default DB_TYPE === 'postgres' ? pool : null;
