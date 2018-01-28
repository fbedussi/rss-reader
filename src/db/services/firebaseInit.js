import * as firebase from "firebase";
import {config} from '../../../package.json';

firebase.initializeApp(config.firebase);

export default firebase;
  