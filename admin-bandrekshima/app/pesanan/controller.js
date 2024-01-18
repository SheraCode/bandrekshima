const path = require('path');
const fs = require('fs');
const config = require('../../config');
const Cart = require('./model');
module.exports = {
    index: async(req,res) => {
        try {
            const cart = await Cart.find({status: { $in: ['Sedang Dikemas', 'Sedang Dikirim'] }})
            .populate('userId');
            const alertMessage = req.flash("alertMessage");
            const alertStatus = req.flash("alertStatus");

            const alert = {message: alertMessage , status: alertStatus}
            res.render('admin/pesanan/view_pengguna', {
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
      
          res.render('admin/pesanan/edit', {
            pesanan,
            title: 'Pesanan'
          });
      
        } catch (err) {
          req.flash('alertMessage', `${err.message}`);
          req.flash('alertStatus', 'danger');
          res.redirect('/pesanan');
        }
      },
      actionEdit: async(req, res)=>{
        try {
          const { id } = req.params;
          const { status } = req.body 
    
          await Cart.findOneAndUpdate({
            _id: id 
          },{ status });
    
          req.flash('alertMessage', "Berhasil Mengubah Status Pesanan")
          req.flash('alertStatus', "success")
          res.redirect('/pesanan')
          
        } catch (err) {
          req.flash('alertMessage', `${err.message}`)
          req.flash('alertStatus', 'danger')
          res.redirect('/pesanan')
        }
      },
      
}