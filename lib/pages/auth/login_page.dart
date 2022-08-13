
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:glow/pages/auth/register_page.dart';
import 'package:glow/service/auth_service.dart';
import 'package:glow/service/database_service.dart';
import 'package:glow/widgets/widgets.dart';

import '../../helper/helper_function.dart';
import '../home_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  AuthService authService = AuthService();
  bool _isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ), */
      body: _isLoading ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)) : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 80.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Glow",
                  style: TextStyle(fontSize: 40,
                      fontWeight: FontWeight.bold, color: Colors.blueGrey),),
                SizedBox(height: 10,),
                Text("Login now to see what they are talking!",
                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500, color: Colors.deepPurpleAccent),),

                //SizedBox(height: 10,),
                Image.asset("assets/login.png",
                  //height: 200,
                  //width: 200,
                ),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: "Email",
                    prefixIcon: Icon(
                      Icons.email,
                      color: Theme.of(context).primaryColor,
                  ),
                ),
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                  validator: (val) {
                    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(val!)
                        ? null : "Please enter a valid email";
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  obscureText: true,
                 decoration: textInputDecoration.copyWith(
                      labelText: "Password",
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Theme.of(context).primaryColor,
                    ),
                  ),
                  validator: (val){
                    if(val!.length < 6){
                      return "Password must be at least 6 characters";}
                    else{
                      return null;
                    }
                  },
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });

                  },
                  ),

              SizedBox(width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),

                ),
                child: Text("Sing In",
                  style: TextStyle(color: Colors.white, fontSize: 16),),
                onPressed: ()  {
                  login();
                },
              ),
              ),
                SizedBox(height: 10,),
                Text.rich(TextSpan(
                  text:"Don't have an account? ",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  children: <TextSpan>[
                    TextSpan(
                      text:"Register here",
                      style: TextStyle(color: Colors.black, decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()..onTap = (){
                        nextScreen(context, RegisterPage());
                      },
                    )
                  ],

                )),
              ],
            ),

          ),
        ),
      ),
    );
  }

  login() async {
    if(formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await authService.loginWithUserNameandPassword(
           email, password).then((value) async {
        if (value == true) {
          QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
              .gettingUserData(email);
          //saving  the values  to our shared preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]["fullName"]);

          nextScreenReplace(context, HomePage());


        } else {
          showSnackBar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }

  }

}
