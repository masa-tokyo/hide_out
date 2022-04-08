const admin = require('firebase-admin');
admin.initializeApp();

const onRequest = require('./src/on_request');

exports.schedule = require('./src/schedule');
exports.onCreate = require('./src/on_create');
exports.onDelete = require('./src/on_delete');

// deploy only necessary functions
exports.modifyDb = onRequest.modifyDb;
exports.testFunction = onRequest.testFunction;







