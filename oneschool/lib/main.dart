//now gimme head por favor
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:oneschool/settings.dart';
import 'package:flutter/material.dart';
import 'rooms.dart';
import 'users.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<MyApp> {
  int _page = 1;
  final GlobalKey _bottomNavigationKey = GlobalKey();

  final List<Widget> _pages = <Widget>[
    const UsersPage(),
    const RoomsPage(),
    SettingsScreen(),
  ];






  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Center(
        child: _pages.elementAt(_page),
      ),





        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 1,
          height: 50.0,
          items: <Widget>[
            Icon(Icons.search, size: 30, color: Colors.white),
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
        ),
        );
  }
}