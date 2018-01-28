import firebase from '../../db/services/firebaseInit';

const auth = firebase.auth();

const logIn = (data) => new Promise((resolve, reject) => {
    if (!data || !data.hasOwnProperty('method')) {
        reject('Login failed: login method missing');
    }

    switch (data.method) {
        case 'email':
            return logInMail(data)
                .then((user) => resolve(user))
                .catch((e) => reject(e));
            break;
        default:
            break;
    }
});

const logInMail = (data) => {
    if (!data || !data.hasOwnProperty('email') || !data.hasOwnProperty('password')) {
        return Promise.reject('Login failed: email or password missing');
    }

    return auth.signInWithEmailAndPassword(data.email, data.password);
}

const logOut = (data) => new Promise((resolve, reject) => {  
    resolve();
});

const signIn = (data) => new Promise((resolve, reject) => {

});

const autInterface = {
  logIn,
  logOut,
  signIn
};

export default autInterface;
