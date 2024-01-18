const CartServices = require("../services/cart.services");

exports.createCart = async (req,res,next) => {
    try {
        const {userId,name,price} = req.body;

        let cart = await CartServices.createCart(userId,name,price);

        res.json({
            status: true,
            success: cart
        });
    } catch (err) {
        next(err)
    }
}


exports.getUserCart = async (req, res, next) => {
    try {
        const { userId } = req.query;

        let cart = await CartServices.getUserCart(userId);

        res.json({
            status: true,
            success: cart
        });
    } catch (err) {
        next(err)
    }
}

exports.getCheckoutUserCart = async (req, res, next) => {
    try {
        const { userId } = req.query;

        let cart = await CartServices.getCheckoutUserCart(userId);

        res.json({
            status: true,
            success: cart
        });
    } catch (err) {
        next(err)
    }
}

exports.checkout = async (req, res, next) => {
    try {
        const { userId } = req.body;

        let checkout = await CartServices.checkout(userId);

        res.json({
            status: true,
            success: checkout
        });
    } catch (err) {
        next(err)
    }
}

exports.deleteCart = async (req, res, next) => {
    try {
      const { id } = req.query;
  
      // Lakukan operasi penghapusan data berdasarkan id
      // Misalnya, menggunakan id untuk menghapus data dari database
      // Sesuaikan dengan logika penghapusan data Anda
  
      // Contoh sederhana:
      const deleted = await CartServices.deleteCart(id);
  
      // Mengembalikan respons setelah penghapusan berhasil
      res.json({
        status: true,
        success: deleted,
      });
    } catch (err) {
      next(err);
    }
  };
  
