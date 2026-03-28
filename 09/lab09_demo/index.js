const express = require("express");

const app = express();

// Read configuration from environment variables
const PORT = process.env.PORT || 4000;
const NODE_ENV = process.env.NODE_ENV || "development";

// GET / — main route
app.get("/", (_req, res) => {
  res.send("Hi Hi");
});

// GET /health — simple health check
app.get("/health", (_req, res) => {
  res.send(`Running in ${NODE_ENV} mode on port ${PORT}`);
});

app.listen(PORT, () => {
  console.log(`Server running in ${NODE_ENV} mode on port ${PORT}`);
});
