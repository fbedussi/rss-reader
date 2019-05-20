import "./style.css";
import { Elm } from "./Main.elm";
import registerServiceWorker from "./registerServiceWorker";
import firebase from "./db/services/firebaseInit";
import * as firebaseui from "firebaseui";
import authInterface from "./auth/authFacade";
import dbInterface from "./db/dbFacade";
import startApp from "./js/elmInteroperability";

// window.authInterface = authInterface;
window.dbInterface = dbInterface;

registerServiceWorker();

var uiConfig = {
  signInOptions: [
    // Leave the lines as is for the providers you want to offer your users.
    firebase.auth.EmailAuthProvider.PROVIDER_ID
  ],
  // Terms of service url.
  tosUrl: "<your-tos-url>"
};

function initLogin() {
  firebase.auth().onAuthStateChanged(
    function(user) {
      if (user) {
        document.querySelector("#firebaseui-auth-container").remove();
        // User is signed in.

        var app = Elm.Main.init({
          node: document.getElementById("root")
        });

        startApp(app, user.uid);
      } else {
        // User is signed out.
        // Initialize the FirebaseUI Widget using Firebase.
        var ui = new firebaseui.auth.AuthUI(firebase.auth());
        // The start method will wait until the DOM is loaded.
        ui.start("#firebaseui-auth-container", uiConfig);
      }
    },
    function(error) {
      console.log(error);
    }
  );
}

window.addEventListener("load", function() {
  initLogin();
});
