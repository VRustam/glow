

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:glow/helper/helper_function.dart';
import 'package:glow/service/database_service.dart';

class AuthService{

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;


  // login

  Future loginWithUserNameandPassword(String email, String password) async{
    try{

      User user = (await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user!;

      if(user != null){

        return true;

      }

    } on FirebaseAuthException catch(e){
      print(e);
      return e.message;
    }

  }





  // register

  Future registerUserWithEmailandPassword(String fullName, String email, String password) async{
    try{

      User user = (await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user!;

      if(user != null){

        DatabaseService(uid: user.uid).savingUserData(fullName, email);  // passowrd sonradan elave olunub

        return true;

      }

    } on FirebaseAuthException catch(e){
      print(e);
      return e.message;
    }

  }



  // logout

Future signOut() async {
    try{
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserNameSF("");
      await HelperFunctions.saveUserEmailSF("");
      await firebaseAuth.signOut();


    }
    catch(e){
      return null;
     // print(e);
    }
}

}