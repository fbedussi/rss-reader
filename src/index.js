import './style.css';
import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';
import authInterface from './auth/authFacade';
import dbInterface from './db/dbFacade';
import openExcerpt from './readMoreButton';

window.authInterface = authInterface;
window.dbInterface = dbInterface;

var app = Main.embed(document.getElementById('root'));

registerServiceWorker();

app.ports.infoForElm.send({
    tag: 'loginResult',
    data: '7woRFDFpHZUehjOSl0IzHaWkBV82'
})

function convertObjToArray(initialArray = []) {
    const resultArray = initialArray.map((obj) => {
        const keys = Object.keys(obj)

        if (keys.indexOf('id') !== -1) {
            return obj;
        } 
        return keys.reduce((acc, key) => obj[key], {});    
    });
    return resultArray
}

function addContent(storeName, content) {
    dbInterface.create({storeName, content})
        // .then((result) => {
        //     console.log(result);
        // })
        .catch((error) => {
            console.log(error);
            app.ports.infoForElm.send({
                tag: 'error',
                data: error
            })
        })
    ;
}

function saveStore(storeName, content) {
    dbInterface.replaceAll({storeName, content})
        .catch((error) => {
            console.log(error);
            app.ports.infoForElm.send({
                tag: 'error',
                data: error
            })
        })
    ;
}

function batchDelete(storeName, idList) {
    const deleteRequests = idList.map(contentId =>dbInterface.delete({storeName, contentId}));

    Promise.all(deleteRequests)
        // .then((result) => {
        //     console.log(result);
        // })
        .catch((error) => {
            console.log(error);
            app.ports.infoForElm.send({
                tag: 'error',
                data: error
            })
        })
    ;
}

function updateContent(storeName, content) {
    dbInterface.update({storeName, content})
        .then((result) => {
            //console.log(result);
        })
        .catch((error) => {
            console.log(error);
            app.ports.infoForElm.send({
                tag: 'error',
                data: error
            })
        })
    ;
}

app.ports.infoForOutside.subscribe(function (cmd) {
    if (!cmd.tag || !cmd.tag.length) {
        return;
    }

    var payload = cmd.data;
    switch (cmd.tag) {
        case 'login':
            authInterface.logIn(payload)
                .then((user) => {
                    app.ports.infoForElm.send({
                        tag: 'loginResult',
                        data: user.uid
                    })
                })
                .catch((error) => {
                    app.ports.infoForElm.send({
                        tag: 'error',
                        data: error
                    })
                })
            ;
            break;
        
        case 'openDb':
            dbInterface.openDb(payload)
                .then((result, error) => {
                    app.ports.infoForElm.send({
                        tag: 'dbOpened',
                        data: result
                    })
                })
                .catch((error) => {
                    app.ports.infoForElm.send({
                        tag: 'error',
                        data: error
                    })
                })
            ;
            break;

        case 'readAllData':
            const readRequests = [
                dbInterface.readAll({storeName: 'categories'}),
                dbInterface.readAll({storeName: 'sites'}),
                dbInterface.readAll({storeName: 'articles'}),
                dbInterface.readAll({storeName: 'appData'})
            ]

            Promise.all(readRequests)
                .then((result, error) => {
                    var resultToSend = {
                        categories: convertObjToArray(result[0]),
                        sites: convertObjToArray(result[1]).map((site) => Object.assign({categoriesId: []}, site)), //if the array is empty firebase strip it
                        articles: convertObjToArray(result[2]),
                        appData: result[3][0],
                    };
                    app.ports.infoForElm.send({
                        tag: 'allData',
                        data: resultToSend
                    })
                })
                .catch((error) => {
                    app.ports.infoForElm.send({
                        tag: 'error',
                        data: error
                    })
                })
            ;
            break;

        case 'addCategory':
            addContent('categories', payload);
            break;

        case 'deleteCategories':
            batchDelete('categories', payload);
            break;

        case 'updateCategory':
            updateContent('categories', payload);
            break;

        case 'addSite':
            addContent('sites', payload);
            break;
        
        case 'deleteSites':
            batchDelete('sites', payload);
            break;

        case 'updateSite':
            updateContent('sites', payload);
            break;
        
        case 'addArticle':
            addContent('articles', payload);
            break;

        case 'deleteArticles':
            batchDelete('articles', payload);
            break;

        case 'saveAllData':
            Object.keys(payload).forEach((key) => saveStore(key, payload[key]));
            break;

        case 'saveAppData':
            saveStore('appData', payload)
            break;

        case 'openExcerpt':
            openExcerpt(payload);
            break;

        default:
            dbInterface[cmd.tag](payload)
                .then((result, error) => {
                    app.ports.infoForElm.send(result)
                })
                .catch((error) => {
                    app.ports.infoForElm.send(error)
                })
            ;
            break;
    }
});