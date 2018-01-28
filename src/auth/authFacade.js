import auth from './services/firebase';

//All methods return a promise
export default {
    logIn: auth.logIn,
    logOut: auth.logOut,
    signIn: auth.signIn
};