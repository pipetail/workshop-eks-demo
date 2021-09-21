const express = require('express')
const winston = require('winston')
const expressWinston = require('express-winston')

const knex = require('knex')({
  client: 'mysql',
  connection: {
    host : 'mysql',
    port : 3306,
    user : 'root',
    password : 'heslojeveslo',
    database : 'test'
  }
});

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
  res.send('Hello World!')
})

app.get('/_probe/ready', (req, res) => {
  res.send("ready")
})

app.get('/_probe/alive', (req, res) => {
  res.send("alive")
})

app.get('/_probe/db/ready', (req, res) => {
  knex.raw("SELECT 1")
      .then(() => {
        console.log("MySQL connected");
        res.send("I'm alive")
      })
      .catch((e) => {
        console.log(e)
        res.status(500).send("it's broken")
      })
})

const server = app.listen(port)
