const express = require('express')
var winston = require('winston')
expressWinston = require('express-winston')

const app = express()
const port = 3000

app.use(expressWinston.logger({
  transports: [
    new winston.transports.Console()
  ],
  format: winston.format.combine(
    winston.format.json()
  ),
  meta: true,
  expressFormat: true,
  colorize: false,
  ignoreRoute: function (req, res) { return false; }
}));

app.get('/', (req, res) => {
  res.send('Hello World (1st)!')
})

const server = app.listen(port)

process.on('SIGINT', shutdown);

// Do graceful shutdown
function shutdown() {
  console.log('graceful shutdown express');
  server.close(function () {
    console.log('closed express');
  });
}

