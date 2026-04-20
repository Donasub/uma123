export const validateSchema = (schema) => {
  return (req, res, next) => {
    try {
      const validated = schema.parse(req.body);
      req.validated = validated;
      next();
    } catch (error) {
      const messages = error.errors.map(e => `${e.path.join('.')}: ${e.message}`);
      res.status(400).json({ error: 'Validation failed', details: messages });
    }
  };
};

export const validateQuery = (schema) => {
  return (req, res, next) => {
    try {
      const validated = schema.parse(req.query);
      req.validated = validated;
      next();
    } catch (error) {
      const messages = error.errors.map(e => `${e.path.join('.')}: ${e.message}`);
      res.status(400).json({ error: 'Validation failed', details: messages });
    }
  };
};
