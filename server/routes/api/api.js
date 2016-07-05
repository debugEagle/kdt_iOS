var express = require('express');
var router = express.Router();

var paper = require('./paper')
var banner = require('./banner')

router.use('/paper', paper);
router.use('/banner', banner);

module.exports = router;
