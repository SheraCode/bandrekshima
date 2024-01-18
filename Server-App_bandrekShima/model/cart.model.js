const mongoose = require('mongoose');
const db = require('../config/db');
const UserModel = require('./user.model');

const {Schema} = mongoose;

const cartSchema = new Schema({
    userId: {
        type: Schema.Types.ObjectId,
        ref:UserModel.modelName
    },
    name: {
        type: String,
    },
    price: {
        type: Number,
    },
    status: {
        type: String,
        default: 'K'
    },
},{timestamps: true});

const CartModel = db.model('cart', cartSchema);

module.exports = CartModel;

