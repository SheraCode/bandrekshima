var express = require('express');
var router = express.Router();
const multer = require('multer');
const os = require('os')
const {index, viewEdit} = require('./controller');

/* GET home page. */
router.get('/', index);
router.get('/edit/:id', viewEdit);

module.exports = router;
