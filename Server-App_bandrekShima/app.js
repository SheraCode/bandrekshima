const express = require('express');
const body_parser = require('body-parser');
const userRouter = require('./routers/user.router');
const CartRouter = require('./routers/cart.router');

const app = express();


app.use(body_parser.json());
app.use('/',userRouter);
app.use('/',CartRouter);

module.exports = app;

