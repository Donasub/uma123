#!/usr/bin/env node

import { execSync } from 'child_process';
import { config } from 'dotenv';
import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

config();

const DB_TYPE = process.env.DB_TYPE || 'postgres';
const command = process.argv[2]; // 'schema' or 'seed'

if (!command || !['schema', 'seed'].includes(command)) {
  console.error('Usage: node scripts/setup-db.js <schema|seed>');
  process.exit(1);
}

const fileName = command === 'schema' ? '01_schema' : '02_seed';
const filePath = join(__dirname, '..', 'sql', `${fileName}${DB_TYPE === 'sqlite' ? '_sqlite' : ''}.sql`);

try {
  if (DB_TYPE === 'sqlite') {
    const dbPath = process.env.DATABASE_URL || './database.sqlite';
    console.log(`Running SQLite ${command} on ${dbPath}...`);
    execSync(`sqlite3 "${dbPath}" < "${filePath}"`, { stdio: 'inherit' });
  } else {
    console.log(`Running PostgreSQL ${command}...`);
    execSync(`psql "${process.env.DATABASE_URL}" -f "${filePath}"`, { stdio: 'inherit' });
  }
  console.log(`✅ ${command} completed successfully`);
} catch (error) {
  console.error(`❌ ${command} failed:`, error.message);
  process.exit(1);
}