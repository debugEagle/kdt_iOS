var express = require('express');
var router = express.Router();

/* GET users listing. */

var ops = {
    eq  : '$eq',
    lt  : '$lt',
    gt  : '$gt',
}


router.get('/:id', function(req, res, next) {
    var id = parseInt(req.params.id) || 0;
    var app = req.app;
    var db = app.get('db');
    if (!db) next();
    var limit = parseInt(req.query.limit) || 1;
    if (limit > 20) limit = 20;
    var op = ops[req.query.op] || '$eq';

    var collection = db.collection('paper');
    collection.findOne({uid: {$exists: true}},{sort:{uid:-1}}, function(err, doc) {
        var maxId = 0;
        if (!err && doc) {
            console.log(err);
            maxId = doc.uid + 1 || 0;
        }
        if (id == 0) {
            id = maxId;
            op = (id == 0) ? '$gt' : '$lt';
        }
        var sort = (op == '$gt') ? 1 : -1;
        var query = {};
        query[op] = id;
        collection.find({uid:query}, {fields:{_id:0}, sort:{uid:sort}}).limit(limit).toArray(function(err, results){
            if (err) next();
            res.json(results || []);
        })
    });
});

module.exports = router;
