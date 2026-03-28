const express = require('express');

const app = express();
const PORT = 4000;

app.get('/', (_req, res) => {
  res.send('<h2>Hello from Docker!</h2>');
});

app.listen(PORT, () => {
  console.log(`App is up and running on port ${PORT}`);
});
