
import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(
    color: Colors.black,
    fontSize: 20.0,
    fontWeight: FontWeight.w300,
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
  ),
  //border: OutlineInputBorder(),
);

void nextScreen(context, page){
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}
void nextScreenReplace(context, page){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
}

void showSnackBar(context, color, message){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message, style: TextStyle(fontSize: 14),),
    backgroundColor: color,
      duration: Duration(seconds: 2),
    action: SnackBarAction(
      label: "OK",
      onPressed: (){},
      textColor: Colors.white,
    ),
  )
  );
}