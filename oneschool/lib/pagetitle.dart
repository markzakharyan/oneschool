import 'package:flutter/material.dart';
AppBar pageTitle(String text, {Widget? icon}){
  return AppBar(
    centerTitle: false,
    title: Text(
      text,
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xff3e5aeb)),
    ),
    actions:
    <Widget>[
      icon ?? Container(),
    ],
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}