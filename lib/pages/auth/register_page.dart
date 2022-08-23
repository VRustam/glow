
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:glow/pages/home_page.dart';

import '../../helper/helper_function.dart';
import '../../service/auth_service.dart';
import '../../widgets/widgets.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  AuthService authService = AuthService();
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _isLoading ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,)) : SingleChildScrollView(
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
                Text("Create your account now to chat and explore!",
                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500, color: Colors.deepPurpleAccent),),

                //SizedBox(height: 10,),
                Image.asset("assets/register.png",
                  //height: 200,
                  //width: 200,
                ),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: "Full Name",
                    prefixIcon: Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      fullName = val;
                    });
                  },
                  validator: (val) {
                  if (val!.isNotEmpty) {
                      return null;
                    }else {
                    return "Name cannot be empty";
                  }
                  },
                ),
                SizedBox(height: 15,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: "Email",
                    prefixIcon: Icon(
                      Icons.email,
                      color: Theme.of(context).primaryColor,
                    )),

                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },

                  validator: (val) {
                    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(val!)
                        ? null
                        : "Please enter a valid email";
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
                    child: Text("Register",
                      style: TextStyle(color: Colors.white, fontSize: 16),),
                    onPressed: ()  {
                      register();
  
                    },
                  ),
                ),
                SizedBox(height: 10,),
                Text.rich(TextSpan(
                  text:"Already have an account? ",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  children: <TextSpan>[
                    TextSpan(
                      text:"Login now",
                      style: TextStyle(color: Colors.black, decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()..onTap = (){
                        nextScreen(context, LoginPage());
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

  register() async {
    if(formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await authService.registerUserWithEmailandPassword(
          fullName, email, password).then((value) async {
        if (value == true) {
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
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
