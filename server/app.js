var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var MongoClient = require('mongodb').MongoClient;

var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');

var routes = require('./routes/index');
var users = require('./routes/users');
var api = require('./routes/api/api')

var app = express();

app.set('etag', false);

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

// uncomment after placing your favicon in /public
//app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
    extended: false
}));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', routes);
app.use('/users', users);
app.use('/api', api)

// catch 404 and forward to error handler
app.use(function(req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    //next(err);
    res.end();
});

var dbpath = 'mongodb://localhost/KDT';

MongoClient.connect(dbpath, function(err, db) {
    if (err) {
        console.log(err);
        throw err;
    }
    var admin = db.admin();
    admin.authenticate('kdt', 'kdt2016', function(err, result) {
        if (err) {
            console.log(err);
        }
        console.log('db 验证成功');
    });
    console.log('db 连接成功');
    app.set('db', db);
})

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
    app.use(function(err, req, res, next) {
        res.status(err.status || 500);
        res.render('error', {
            message: err.message,
            error: err
        });
    });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
        message: err.message,
        error: {}
    });
});


module.exports = app;
