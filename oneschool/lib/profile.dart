import 'package:flutter/material.dart';
import 'pagetitle.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: pageTitle('Profile'),
      body: Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(
        bottom: 200,
      ),
      child: const Text('Profile Page'),
    ),
    );
  }
}