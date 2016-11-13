/**
 * Copyright (c) 2016 chat-ng2-fb3. All rights reserved
 * 
 * REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS,
 * WITH OR WITHOUT MODIFICATION, ARE NOT PERMITTED.
 * 
 * DO NOT ALTER OR REMOVE THIS HEADER.
 * 
 * Created on : 13/11/16
 * Author     : bwnyasse
 *  
 */


@Injectable()
class FirebaseService {

  fb.Auth _fbAuth;
  fb.GoogleAuthProvider _fbGoogleAuthProvider;
  fb.Database _fbDatabase;
  fb.Storage _fbStorage;
  fb.DatabaseReference _fbRefMessages;

  // Constructor
  FirebaseService() {
    fb.initializeApp(
        apiKey: "AIzaSyAtMjBLUocXKSxxaFnHgVw7UkB0YiBTFEk",
        authDomain: "chat-ng2-fb3.firebaseapp.com",
        databaseURL: "https://chat-ng2-fb3.firebaseio.com",
        storageBucket: "chat-ng2-fb3.appspot.com");
  }
}
