// i think i deserve head now por favor
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'profile.dart';
import 'package:flutter/material.dart';
import 'rooms.dart';
import 'users.dart';
import 'package:home_indicator/home_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signintest.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';


User? _user;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance.authStateChanges().listen((User? user) {

    _user = user;
    //print(_user);
  });

  await HomeIndicator.hide();
  runApp(
    Phoenix(
        child: MaterialApp(home: _user != null ? MyApp() : SignUp4(themeBloc: ThemeBloc()))
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<MyApp> {
  int _page = 1;
  final GlobalKey bottomNavigationKey = GlobalKey();

  final List<Widget> _pages = <Widget>[
    const UsersPage(),
    const RoomsPage(),
    ProfileScreen(),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Center(
        child: _pages.elementAt(_page),
      ),

        bottomNavigationBar: ((_user?.email?.split('@')[1] == 'iusd.org') && (_user?.email?.substring(0,2)) != null) ? CurvedNavigationBar(
          key: bottomNavigationKey,
          index: 1,
          height: 50.0,
          items: <Widget>[
            Icon(Icons.maps_ugc, size: 30, color: Colors.white),
            Icon(Icons.group, size: 30, color: Colors.white),

            Icon(Icons.account_circle, size: 30, color: Colors.white),
          ],
          color: Color(0xff3e5aeb),
          buttonBackgroundColor: Color(0xff3e5aeb),
          backgroundColor: Colors.white24,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 200),
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
        ) : null,
        );
  }
}