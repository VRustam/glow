import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:glow/helper/helper_function.dart';
import 'package:glow/pages/auth/login_page.dart';
import 'package:glow/pages/profile.dart';
import 'package:glow/pages/search_page.dart';
import 'package:glow/service/auth_service.dart';

import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  String email = "";

  AuthService authService = AuthService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) => {
          setState(() {
            email = value!;
          })
        });

    await HelperFunctions.getUserNameFromSF().then((value) => {
          setState(() {
            userName = value!;
          })
        });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: (){
                nextScreen(context, const SearchPage());
              },
              icon: Icon(Icons.search),
          )
        ],
        elevation: 0,
        title: Text("Glow",style: TextStyle(
          color: Colors.white,
          fontSize: 27,
          fontWeight: FontWeight.bold,
        )),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,

      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 150,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 15,),
            Text(userName,
            textAlign: TextAlign.center,
              style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            ),
            SizedBox(height: 30,),
            Divider(height: 2,),
            ListTile(
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              onTap: (){
               // Navigator.pop(context);
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.group, color: Theme.of(context).primaryColor,),
              title: Text("Groups",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),

            ListTile(
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              onTap: (){
                nextScreenReplace(context, ProfilePage(
                  userName: userName,
                  email: email,
                ));
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.account_circle, color: Theme.of(context).primaryColor,),
              title: Text("Profile",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),


            ListTile(
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              onTap: () async{
                showDialog(
                  barrierDismissible: false,
                    context: context,
                    builder: (context){
                  return AlertDialog(
                    title: Text("Logout"),
                    content: Text("Are you sure you want to logout?"),
                    actions: [
                      IconButton(
                        onPressed: (){
                          Navigator.pop(context);

                        }, icon: Icon(Icons.cancel, color: Colors.red,),),
                      IconButton(
                        onPressed: (){
                          authService.signOut();
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoginPage()), (route) => false);

                        }, icon: Icon(Icons.done, color: Colors.green,),),
                    ],
                  );
                });
                
                //authService.signOut().whenComplete(() {
                  // nextScreenReplace(context, LoginPage());

              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.exit_to_app, color: Theme.of(context).primaryColor,),
              title: Text("Logout",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

