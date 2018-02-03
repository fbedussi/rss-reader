import firebase from './firebaseInit';

const db = firebase.database();
var userUid;

const openDb = (uid) => new Promise((resolve, reject) => {
  userUid = uid;
  console.log('UID', userUid);
  resolve(true);
});

const createInStore = ({storeName = 'data', content}) => db
    .ref(`users/${userUid}/${storeName}/${content.id}`)
    .set(content)
;

const readInStore = ({storeName, contentId}) => db
  .ref(`users/${userUid}/${storeName}/${contentId}`)
  .once('value')
  .then((snapshot) => snapshot.val())
;

const readAllInStore = ({storeName = 'data'}) => db
  .ref(`users/${userUid}/${storeName}`)
  .once('value')
  .then((snapshot) => [].concat(snapshot.val()).filter((i) => i)) //convert everything into an array
;

const updateInStore = ({storeName, content}) => db
  .ref(`users/${userUid}/${storeName}/${content.id}`)
  .update(content)
;

const deleteInStore = ({storeName, contentId}) => db
    .ref(`users/${userUid}/${storeName}/${contentId}`)
    .remove()
;
  
const replaceAllInStore = ({storeName, content}) => db
  .ref(`users/${userUid}/${storeName}`)
  .set(content)
;


const dbInterface = {
  openDb,

  create: createInStore,
  read: readInStore,
  readAll: readAllInStore,
  update: updateInStore,
  delete: deleteInStore,
  replaceAll: replaceAllInStore,
};

export default dbInterface;
