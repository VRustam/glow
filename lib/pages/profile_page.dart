

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glow/service/auth_service.dart';

import '../widgets/widgets.dart';
import 'auth/login_page.dart';
import 'home_page.dart';

class ProfilePage extends StatefulWidget {

  String userName = "";
  String email = "";

  ProfilePage({Key? key, required this.email, required this.userName,}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Profile",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 30),
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 150,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 15,),
            Text(
              widget.userName,
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

              onTap: (){
                nextScreen(context, HomePage());
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
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 170),
        child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:<Widget>[
              Icon(
                Icons.account_circle,
                size: 200,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Full Name", style: TextStyle(fontSize: 17),),
                  Text(
                    widget.userName,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:<Widget>[
                  Text("Email", style: TextStyle(fontSize: 17),),
                  Text(
                    widget.email,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),

            ]
        ),
      ),
    );
  }
}
