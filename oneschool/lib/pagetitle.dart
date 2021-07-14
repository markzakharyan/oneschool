import 'package:flutter/material.dart';

AppBar pageTitle(String text, {bool search = false}){
  return AppBar(
    centerTitle: false,
    title: Text(
      text,
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xff3e5aeb)),
    ),
    actions: search == false ? [] :
    <Widget>[
      IconButton(
        icon: Icon(
          Icons.search,
          color: Color(0xff3e5aeb),
        ),
        onPressed: () {
          // do something
        },
      )
    ],
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}