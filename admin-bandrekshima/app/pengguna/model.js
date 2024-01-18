const mongoose = require('mongoose');
let newsSchema = mongoose.Schema({
    email: {
        type: String,
    },
    name: {
        type: String,
    },
    telepon: {
        type: Number,
    },
    address: {
        type: String,
    },
    password: {
        type: String,
    }
},
{timestamps: true}
)
module.exports = mongoose.model('user' , newsSchema);