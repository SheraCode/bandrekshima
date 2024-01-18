const Pengguna = require('./model');
const path = require('path');
const fs = require('fs');
const config = require('../../config');
module.exports = {
    index: async(req,res) => {
        try {
            const pengguna = await Pengguna.find()
                
            const alertMessage = req.flash("alertMessage");
            const alertStatus = req.flash("alertStatus");

            const alert = {message: alertMessage , status: alertStatus}
            res.render('admin/pengguna/view_pengguna', {
                title: 'Pengguna',
                pengguna,
                alert
            });
        } catch (err) {
            req.flash('alertMessage', `${err.message}`)
            req.flash('alertStatus','danger')
            console.log(err);
        }
    },    
}