import './main.css';
import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';
import authInterface from './auth/authFacade';
import dbInterface from './db/dbFacade';

window.authInterface = authInterface;
window.dbInterface = dbInterface;

var app = Main.embed(document.getElementById('root'));

registerServiceWorker();

app.ports.infoForElm.send({
    tag: 'loginResult',
    data: '7woRFDFpHZUehjOSl0IzHaWkBV82'
})

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
                dbInterface.readAll({storeName: 'categories'})    
            ]

            Promise.all(readRequests)
                .then((result, error) => {
                    const resultObj = result[0] ? result[0] : [];
                    const resultArray = Object.keys(resultObj).map((key) => resultObj[key]);
                    var resultToSend = resultArray;
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
            batchDelte('categories', payload);
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