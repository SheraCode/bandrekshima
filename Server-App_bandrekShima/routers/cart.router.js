const router = require('express').Router();
const CartController = require("../controller/cart.controller");

router.post('/storeCart',CartController.createCart);

router.get('/getUserCart',CartController.getUserCart);
router.get('/getCheckoutUserCart',CartController.getCheckoutUserCart);
router.put('/checkout',CartController.checkout);

router.post('/deleteCart',CartController.deleteCart);

module.exports = router;