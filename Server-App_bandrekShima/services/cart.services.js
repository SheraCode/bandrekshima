const CartModel = require("../model/cart.model");

class CartServices {
    static async createCart(userId,name,price) {
        const createCart = new CartModel({userId,name,price});
        return await createCart.save();
    }

    static async getUserCart(userId) {
        const CartData = await CartModel.find({ userId, status: 'K' });
        return CartData;
    }

    static async getCheckoutUserCart(userId, status) {
        const CartData = await CartModel.find({ userId, status: { $in: ['Sedang Dikemas', 'Sedang Dikirim'] } });
        return CartData;
    }
    

    static async deleteCart(id) {
        const deleted = await CartModel.deleteOne({_id:id});
        console.log(deleted);
        return deleted;
    }

    static async checkout(userId) {
        try {
            console.log('Attempting checkout for userId:', userId);
    
            const updated = await CartModel.updateMany(
                { userId: userId, status: 'K' },
                { $set: { status: 'Sedang Dikemas' } }
            );
    
            console.log('Updated result:', updated);
    
            if (updated && updated.nModified > 0) {
                console.log("Berhasil mengupdate status");
            } else {
                console.log("Tidak ada dokumen yang memenuhi kriteria pencarian");
            }
    
            return updated;
        } catch (error) {
            console.error('Error during checkout:', error);
            throw error;
        }
    }
            
    
    
}

module.exports = CartServices;