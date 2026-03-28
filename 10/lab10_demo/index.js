const express = require('express');
const mongoose = require('mongoose');
const Item = require('./models/Item');

const app = express();
const PORT = process.env.PORT || 3000;
const MONGO_URI = process.env.MONGO_URI || 'mongodb://admin:password@mongo:27017/lab10db?authSource=admin';

// ── Middleware ────────────────────────────────────────────────────────────────
app.use(express.json());

// ── MongoDB Connection ────────────────────────────────────────────────────────
mongoose
  .connect(MONGO_URI)
  .then(() => console.log('MongoDB connected'))
  .catch((err) => console.error('MongoDB connection error:', err.message));

// ── Routes ────────────────────────────────────────────────────────────────────

// Health check + env info
app.get('/', (_req, res) => {
  const dbState = mongoose.connection.readyState === 1 ? 'connected' : 'disconnected';
  res.json({
    message: 'Lab 10 Demo',
    env: process.env.NODE_ENV,
    db: dbState,
  });
});

// Get all items
app.get('/items', async (_req, res) => {
  try {
    const items = await Item.find();
    res.json(items);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Create a new item
app.post('/items', async (req, res) => {
  try {
    const item = await Item.create({ name: req.body.name });
    res.status(201).json(item);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ── Start Server ──────────────────────────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT} | NODE_ENV=${process.env.NODE_ENV}`);
});
