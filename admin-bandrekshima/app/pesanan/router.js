var express = require('express');
var router = express.Router();
const multer = require('multer');
const os = require('os')
const {index, viewEdit, actionEdit} = require('./controller');

/* GET home page. */
router.get('/', index);
router.get('/edit/:id', viewEdit);
router.put('/edit/:id', actionEdit);

module.exports = router;
