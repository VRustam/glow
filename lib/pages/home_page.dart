import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:glow/helper/helper_function.dart';
import 'package:glow/pages/auth/login_page.dart';
import 'package:glow/pages/profile.dart';
import 'package:glow/pages/search_page.dart';
import 'package:glow/service/auth_service.dart';
import 'package:glow/service/database_service.dart';
import 'package:glow/widgets/group_tile.dart';

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
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }

  //string manipulation
  String getId(String res){
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res){
    return res.substring(res.indexOf("_")+1);
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


    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot){
      setState(() {
        groups = snapshot;
      });
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
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          popUpDialog(context);
        },
        elevation: 0,
        child: Icon(Icons.add,
        color: Colors.white,
        size: 30,),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  popUpDialog(BuildContext context){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder:((context, setState){
                return AlertDialog(
                  title: Text("Create Group"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _isLoading == true ? Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      ) : TextField(
                        onChanged: (val){
                          setState(() {
                            groupName = val;
                          });
                        },
                        style: TextStyle(
                          //fontSize: 20,
                          //fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              //width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              //width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              //width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),

                    ],
                  ),
                  actions: [
                    ElevatedButton(onPressed:(){
                      Navigator.of(context).pop();
                    },
                      child: Text("Cancel"),
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                      ),),
                    ElevatedButton(onPressed:() async {
                      if(groupName !=""){
                        setState((){
                          _isLoading = true;
                        });
                        DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                            .createGroup(groupName, FirebaseAuth.instance.currentUser!.uid, userName)
                            .whenComplete((){
                          _isLoading = false;
                        });
                        Navigator.of(context).pop();
                        showSnackBar(context, Colors.green, "Group created successfully");
                      }
                    },
                      child: Text("Create"),
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                      ),),
                  ],

                );
              }));
        });
  }


  groupList(){
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot){

        //make some checks
        if(snapshot.hasData){
          if(snapshot.data['groups'] != null){
            if(snapshot.data['groups'].length != 0){
              return ListView.builder(
                itemCount:snapshot.data['groups'].length,
                itemBuilder: (context, index){
                  int reverseIndex = snapshot.data['groups'].length - index - 1;
                  return GroupTile(

                    groupId: getId(snapshot.data['groups'][reverseIndex]),
                    groupName: getName(snapshot.data['groups'][reverseIndex]),
                    userName: snapshot.data['fullName'],
                    );
                },
              );

            }else{
              return noGroupWidget();
            }

          }else{
            return noGroupWidget();
          }

        }else{
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );

        }

      },
    );
  }



  noGroupWidget(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          GestureDetector(
            onTap: (){
              popUpDialog(context);
            },
            child: Icon(
              Icons.add_circle,
              size: 75,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 20,),
          Text("You've not joined any groups, tap on the add icon to creat a group or also search from top search button.", textAlign: TextAlign.center,)
        ]
      ),
    );

  }


}

