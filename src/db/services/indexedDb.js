if (!('indexedDB' in window)) {
    throw new Error('This browser doesn\'t support IndexedDB');
}

var db;

const openDb = (dbName, user) => new Promise((resolve, reject) => {
    const request = indexedDB.open(dbName);
    var newDb = false;

    request.onerror = (event) => reject(`Error opening DB ${dbName}: ${request.error}`);

    request.onupgradeneeded = (event) => {
        const db = event.target.result;

        try {
            db.createObjectStore('activity', { keyPath: "id" });
        } catch(e) {
            reject('Error creating Activity store');
        }

        try {
            db.createObjectStore('client', { keyPath: "id" });
        } catch(e) {
            reject('Error creating Client store');
        }

        try {
            db.createObjectStore('bill', { keyPath: "id" });
        } catch(e) {
            reject('Error creating Bill store');
        }

        try {
            db.createObjectStore('option', { keyPath: "id" });
        } catch(e) {
            reject('Error creating Option store');
        } 

        newDb = true;
    };
    
    request.onsuccess = (event) => {
        db = event.target.result;
        if (newDb) {
            createInStore('option', {id: 1});
        }
        resolve(dbInterface)
    };
});

const createInStore = (storeName, content) => new Promise((resolve, reject) => {
    const transaction = db.transaction([storeName], 'readwrite');
    const request = transaction
        .objectStore(storeName)
        .add(content)
    ;

    transaction.onerror = () => reject(`Error writing to ${storeName}: ${transaction.error}`); 

    request.onerror = (event) => reject(`Error writing ID ${content.id} to ${storeName}: ${request.error}`);

    request.onsuccess = (event) => resolve(request.result); //key
});

const readInStore = (storeName, contentId) => new Promise((resolve, reject) => {
    const transaction = db.transaction([storeName]);
    const request = transaction
        .objectStore(storeName)
        .get(contentId)
    ;

    transaction.onerror = () => reject(`Error reading from ${storeName}: ${transaction.error}`);    

    request.onerror = (event) => reject(`Error reading ID ${contentId} from ${storeName}: ${request.error}`);

    request.onsuccess = (event) => resolve(request.result);
});

const readAllInStore = (storeName) => new Promise((resolve, reject) => {
    const transaction = db.transaction([storeName]) ;
    const request = transaction
        .objectStore(storeName)
        .getAll()
    ;

    transaction.onerror = () => reject(`Error reading from ${storeName}: ${transaction.error}`);        

    request.onerror = (event) => reject(`Error reading from ${storeName}: ${request.error}`);

    request.onsuccess = (event) => resolve(request.result);
});

const updateInStore = (storeName, content) => new Promise((resolve, reject) => {
    const transaction = db.transaction([storeName], "readwrite");
    const objectStore = transaction.objectStore(storeName);
    const request = objectStore.get(content.id);

    transaction.onerror = () => reject(`Error writing to ${storeName}: ${transaction.error}`);        
    
    request.onerror = (event) => reject(`Error reading ID ${content.id} from ${storeName}: ${request.error}`);

    request.onsuccess = (event) => {
        // Get the old value that we want to update
        const oldContent = event.target.result;

        // update the value(s) in the object that you want to change
        const newContent = Object.assign({}, oldContent, content);

        // Put this updated object back into the database.
        const request = objectStore.put(newContent);

        request.onerror = (event) => reject(`Error updating ID ${content.id} from ${storeName}: ${request.error}`);

        request.onsuccess = (event) => resolve(request.result);
    };
});

const deleteInStore = (storeName, contentId) => new Promise((resolve, reject) => {
    const transaction = db.transaction([storeName], "readwrite");
    const request = transaction
        .objectStore(storeName)
        .delete(contentId)
    ;

    transaction.onerror = () => reject(`Error writing to ${storeName}: ${transaction.error}`);            

    request.onsuccess = (event) => resolve(request.result === undefined);

    request.onerror = (event) => reject(`Error deleting ID ${contentId} in ${storeName}: ${request.error}`);
});

const replaceAllInStore = (storeName, data) => new Promise((resolveReplaceAll, rejectReplaceAll) => {
    const transaction = db.transaction([storeName], 'readwrite');
    const clearRequest = transaction
        .objectStore(storeName)
        .clear()
    ;
    
    transaction.onerror = () => rejectReplaceAll(`Error writing to ${storeName}: ${transaction.error}`);

    clearRequest.onerror = (event) => rejectReplaceAll(`Error clearing ${storeName}: ${clearRequest.error}`);

    clearRequest.onsuccess = (event) => {
        const writeDataPromises = data.map((record) => new Promise((resolveSingleRecord, rejectSingleRecord) => {
            const addRequest = transaction
                .objectStore(storeName)
                .add(record)
            ;
    
            addRequest.onerror = (event) => rejectSingleRecord(`Error writing ID ${record.id} to ${storeName}: ${addRequest.error}`);
    
            addRequest.onsuccess = (event) => resolveSingleRecord(addRequest.result); //key
        }));

        Promise.all(writeDataPromises)
            .then((data) => resolveReplaceAll(data))
            .catch((e) => rejectReplaceAll(e))
        ;
    }
});

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