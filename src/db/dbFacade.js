import {config} from '../../package.json';
import firebase from './services/firebase';

var db;

db = firebase;

//All methods return a promise
export default {
    openDb: db.openDb,

    create: db.create,
    read: db.read,
    readAll: db.readAll,
    update: db.update,
    delete: db.delete,
    replaceAll: db.replaceAll
};