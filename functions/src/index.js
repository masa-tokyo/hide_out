const admin = require('firebase-admin');
admin.initializeApp();


const modifyDb = require('./modify_db');

exports.onSchedule = require('./on_schedule');

// deploy only necessary functions
exports.modifyDb = modifyDb.modifyDb;





