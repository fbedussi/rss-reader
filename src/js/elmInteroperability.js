import { toggleExcerpt, initReadMoreButtons } from "./readMoreButton";
import debounce from "./debounce";
import initBackToTopButton from "./backToTopButton";
import firebase from "../db/services/firebaseInit";

function convertObjToArray(initialArray = []) {
  const resultArray = initialArray.map(obj => {
    const keys = Object.keys(obj);

    if (keys.indexOf("id") !== -1) {
      return obj;
    }
    return keys.reduce((acc, key) => obj[key], {});
  });
  return resultArray;
}

function addContent(app, storeName, content) {
  dbInterface
    .create({ storeName, content })
    // .then((result) => {
    //     console.log(result);
    // })
    .catch(error => {
      console.log(error);
      app.ports.infoForElmPort.send({
        tag: "error",
        data: error
      });
    });
}

function saveStore(app, storeName, content) {
  dbInterface.replaceAll({ storeName, content }).catch(error => {
    console.log(error);
    app.ports.infoForElmPort.send({
      tag: "error",
      data: error
    });
  });
}

function batchDelete(app, storeName, idList) {
  const deleteRequests = idList.map(contentId =>
    dbInterface.delete({ storeName, contentId })
  );

  Promise.all(deleteRequests)
    // .then((result) => {
    //     console.log(result);
    // })
    .catch(error => {
      console.log(error);
      app.ports.infoForElmPort.send({
        tag: "error",
        data: error
      });
    });
}

function updateContent(app, storeName, content) {
  dbInterface
    .update({ storeName, content })
    .then(result => {
      //console.log(result);
    })
    .catch(error => {
      console.log(error);
      app.ports.infoForElmPort.send({
        tag: "error",
        data: error
      });
    });
}

function watchForArticleChange() {
  const mainContent = document.querySelector(".mainContent");
  const config = { childList: true, subtree: true };
  const observer = new MutationObserver(debounce(initReadMoreButtons, 50));

  observer.observe(mainContent, config);

  window.addEventListener("resize", debounce(initReadMoreButtons, 50));
}

function elmIteroperability(app, uid) {
  app.ports.infoForElmPort.send({
    tag: "loginResult",
    data: uid
  });

  app.ports.infoForOutside.subscribe(function(cmd) {
    if (!cmd.tag || !cmd.tag.length) {
      return;
    }

    var payload = cmd.data;
    switch (cmd.tag) {
      case "login":
        authInterface
          .logIn(payload)
          .then(user => {
            app.ports.infoForElmPort.send({
              tag: "loginResult",
              data: user.uid
            });
          })
          .catch(error => {
            app.ports.infoForElmPort.send({
              tag: "error",
              data: error
            });
          });
        break;

      case "openDb":
        dbInterface
          .openDb(payload)
          .then((result, error) => {
            app.ports.infoForElmPort.send({
              tag: "dbOpened",
              data: result
            });
          })
          .catch(error => {
            app.ports.infoForElmPort.send({
              tag: "error",
              data: error
            });
          });
        break;

      case "readAllData":
        const readRequests = [
          dbInterface.readAll({ storeName: "categories" }),
          dbInterface.readAll({ storeName: "sites" }),
          dbInterface.readAll({ storeName: "articles" }),
          dbInterface.readAll({ storeName: "options" }),
          dbInterface.readAll({ storeName: "lastRefreshedTime" })
        ];

        Promise.all(readRequests)
          .then((result, error) => {
            var resultToSend = {
              categories: convertObjToArray(result[0]),
              sites: convertObjToArray(result[1]).map(site =>
                Object.assign({ categoriesId: [] }, site)
              ), //if the array is empty firebase strip it
              articles: Object.values(result[2][0]),
              options: result[3][0],
              lastRefreshedTime:
                result[4][0] && result[4][0].lastRefreshedTime
                  ? result[4][0].lastRefreshedTime
                  : 0
            };

            initBackToTopButton();
            watchForArticleChange();

            app.ports.infoForElmPort.send({
              tag: "allData",
              data: resultToSend
            });
          })
          .catch(error => {
            app.ports.infoForElmPort.send({
              tag: "error",
              data: error.message
            });
          });
        break;

      case "addCategory":
        addContent(app, "categories", payload);
        break;

      case "deleteCategories":
        batchDelete(app, "categories", payload);
        break;

      case "updateCategory":
        updateContent(app, "categories", payload);
        break;

      case "addSite":
        addContent(app, "sites", payload);
        break;

      case "deleteSites":
        batchDelete(app, "sites", payload);
        break;

      case "updateSite":
        updateContent(app, "sites", payload);
        break;

      case "addArticle":
        addContent(app, "articles", payload);
        break;

      case "deleteArticles":
        batchDelete(app, "articles", payload);
        break;

      case "saveAllData":
        Object.keys(payload).forEach(key => saveStore(app, key, payload[key]));
        break;

      case "saveOptions":
        saveStore(app, "options", payload);
        break;

      case "saveLastRefreshedTime":
        saveStore(app, "lastRefreshedTime", payload);
        break;

      case "toggleExcerpt":
        toggleExcerpt(payload);
        break;

      // case 'initReadMoreButtons':
      //     initBackToTopButton();
      //     watchForArticleChange();
      //     break;

      case "scrollToTop":
        document.scrollingElement.scrollTop = 0;
        break;

      case "signOut":
        firebase
          .auth()
          .signOut()
          .then(() => window.location.reload())
          .catch(error => console.log(error));
        break;
    }
  });
}

export default elmIteroperability;
