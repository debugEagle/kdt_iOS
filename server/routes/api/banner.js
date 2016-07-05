var express = require('express');
var router = express.Router();


router.get('/', function(req, res, next) {
    var app = req.app;
    var db = app.get('db');
    if (!db) next();
    /* 要查2次 现查最大值 */
    var collection = db.collection('banner');
    collection.findOne({uid: {$exists: true}},{sort:{uid:-1}}, function(err, doc) {
        var maxId = 0;
        if (!err && doc) {
            console.log(err);
            maxId = doc.uid + 1 || 0;
        }
        var limit = 4;  /* 返回banner数量 */
        var sort = -1;  /* 降序 */
        var query = {};
        query['$lt'] = maxId;
        console.log(query);
        var collection = db.collection('banner');
        collection.find({uid:query}, {fields:{_id:0}, sort:{uid:sort}}).limit(limit).toArray(function(err, results){
            if (err) next();
            res.json(results || []);
        })
    });
});

module.exports = router;
