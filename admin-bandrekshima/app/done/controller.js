const path = require('path');
const fs = require('fs');
const config = require('../../config');
const Cart = require('../pesanan/model');
module.exports = {
    index: async(req,res) => {
        try {
            const cart = await Cart.find({status: { $in: ['Pesanan Selesai'] }})
            .populate('userId');
            const alertMessage = req.flash("alertMessage");
            const alertStatus = req.flash("alertStatus");

            const alert = {message: alertMessage , status: alertStatus}
            res.render('admin/done/view_pengguna', {
                title: 'Pesanan',
                cart,
                alert
            });
        } catch (err) {
            req.flash('alertMessage', `${err.message}`)
            req.flash('alertStatus','danger')
            console.log(err);
        }
    },    

    viewEdit: async (req, res) => {
        try {
          const { id } = req.params;
      
          const pesanan = await Cart.findOne({ _id: id }).populate('userId');
      
          res.render('admin/done/edit', {
            pesanan,
            title: 'Pesanan'
          });
      
        } catch (err) {
          req.flash('alertMessage', `${err.message}`);
          req.flash('alertStatus', 'danger');
          res.redirect('/pesanansselesai');
        }
      },
}