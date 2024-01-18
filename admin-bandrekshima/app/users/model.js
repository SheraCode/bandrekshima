const mongoose = require('mongoose')

let userSchema = mongoose.Schema({
  email: {
    type: String,
    require: [true, 'email harus diisi']
  },
  name: {
    type: String,
    require: [true, 'nama harus diisi']
  },
  password: {
    type: String,
    require: [true, 'kata sandi harus diisi']
  },
  status: {
    type: String,
    require: [true, 'Status sandi harus diisi']
  },
}, { timestamps: true })

module.exports = mongoose.model('admin', userSchema)
