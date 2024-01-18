const mongoose = require('mongoose');
const UserModel = require('../pengguna/model');

let newsSchema = mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: UserModel.modelName
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
},
{ timestamps: true }
);

module.exports = mongoose.model('cart', newsSchema);
