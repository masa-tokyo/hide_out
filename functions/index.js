const admin = require('firebase-admin');
admin.initializeApp(
    // {
    //     databaseURL: 'https://console.firebase.google.com/u/1/project/voiceput-e9f38/firestore/data/~2F',
    // }
);

const modifyDb = require('./src/modify_db');

exports.onSchedule = require('./src/on_schedule');
exports.onCreate = require('./src/on_create');

// deploy only necessary functions
exports.modifyDb = modifyDb.modifyDb;







