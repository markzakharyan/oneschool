import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'signintest.dart';
import 'pagetitle.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({Key? key}) : super(key: key);

  @override
  _RoomsPageState createState() => _RoomsPageState();

}



Widget latestMessageAgoFormat(String text) {
  return Text(text,
      style: TextStyle(color: text == 'ERROR' ? Colors.red : Colors.grey[350]),
  );
}


var latestMessageAgo;
Widget _latestMessageAgo(types.Room room) {
  return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('rooms')
          .doc('${room.id}')
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return latestMessageAgoFormat('ERROR');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return latestMessageAgoFormat(latestMessageAgo == null
              ? 'Loading...'
              : latestMessageAgo);
        }

        Map<String, dynamic> dataMap = snapshot.data!.data() as Map<String, dynamic>; //When in doubt, use a hashmap :D
        latestMessageAgo = dataMap.containsKey('lastMessages')
            ? timeago.format(dataMap['lastMessages'][0]['createdAt'].toDate())
            : '';

        return latestMessageAgoFormat(latestMessageAgo);
      });
}


Widget latestMessageFormat(String text) {
  return Text(text,
      style: TextStyle(color: text == 'Something went wrong collecting the latest message' ? Colors.red : Colors.grey, fontSize: 15, height: 1.1),
      maxLines: 2,
      overflow: TextOverflow.ellipsis);
}

var latestMessageDisplayText;
Widget _latestMessage(types.Room room) {
  return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('rooms')
          .doc('${room.id}')
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return latestMessageFormat('Something went wrong collecting the latest message');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return latestMessageFormat(latestMessageDisplayText == null
              ? 'Loading...'
              : latestMessageDisplayText);
        }

        Map<String, dynamic> dataMap = snapshot.data?.data() as Map<String, dynamic>; //When in doubt, use a hashmap :D
        latestMessageDisplayText = dataMap.containsKey('lastMessages')
            ? dataMap['lastMessages'][0]['text']
            : 'No messages yet';

        return latestMessageFormat(latestMessageDisplayText);
      });
}





class _RoomsPageState extends State<RoomsPage> {

  bool _error = false;
  bool _initialized = false;
  User? _user;


  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
  }

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        setState(() {
          _user = user;
        });
      });
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }




  Widget _verifiedText(chatType, text) {
    if (['course','schoolClub','schoolSport','offSchoolSport'].contains(chatType)) {
      return RichText(
        text: TextSpan(
          style: TextStyle(fontSize:18,color:Colors.black),
          children: [
            TextSpan(text: text),
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child:Icon(
                  Icons.check_circle,
                  color:  chatType == 'course' ? Color(0xff3e5aeb) : Colors.amber,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      );
    }
    else{
      return Text(text, style: TextStyle(fontSize:18,color:Colors.black));
    }
  }

  Widget _verifiedIcon(chatType) {
    if (['course','schoolClub','schoolSport','offSchoolSport'].contains(chatType)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          //padding: EdgeInsets.all(3),
          width: 20,
          height: 20,
          color: Colors.white,
          child: ClipRRect(
            //borderRadius: BorderRadius.circular(5),
            child: Icon(
              Icons.check_circle,
              color:  chatType == 'course' ? Color(0xff3e5aeb) : Colors.amber,
              size: 20,
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Future reachedEndOfChat(types.Room room) async{
    return await FirebaseFirestore.instance.collection('rooms').doc('${room.id}').update({
      'lastSeen' : {'${FirebaseChatCore.instance.firebaseUser!.uid}':DateTime.now()}
    });
  }

  @override
  Widget build(BuildContext context) {

    void logout() async {
      await FirebaseAuth.instance.signOut();
      await Phoenix.rebirth(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => SignUp4(themeBloc: ThemeBloc()),
          ),
              (route)=>false
      );
    }


    if (_error) {
      return Container();
    }

    if (!_initialized) {
      return Container();
    }

    return Scaffold(

      appBar: pageTitle(((_user?.email?.split('@')[1] == 'iusd.org') && (_user?.email?.substring(0,2)) != null) ? 'Messages' : 'Parent Account',
      icon: IconButton(
        icon: Icon(
          Icons.logout,
          color: Color(0xff3e5aeb),
        ),
        onPressed: () {
          logout();
          //do something
        },
      )
      ),

      body: _user == null
          ? Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                bottom: 200,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Not authenticated'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => SignUp4(themeBloc: ThemeBloc()),
                        ),
                        (route)=>false
                      );
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            )
          : StreamBuilder<List<types.Room>>(
              stream: FirebaseChatCore.instance.rooms(orderByUpdatedAt: true),
              initialData: const [],
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(
                      bottom: 200,
                    ),
                    child: ((_user?.email?.split('@')[1] == 'iusd.org') && (_user?.email?.substring(0,2)) != null) ?
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                            'No Chats Yet',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xff9e9cab),
                            fontFamily: 'Avenir',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            //bottomNavigationKey = 0;
                          },
                          child: const Text(
                              'Create One',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xff3e5aeb),
                              fontFamily: 'Avenir',
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ) : Center(
                      child:Container(
                        alignment: Alignment.center,
                        //margin: const EdgeInsets.only(bottom: 200,),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('For Safety and Security Reasons',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xff9e9cab),
                              fontFamily: 'Avenir',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),

                          ),

                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(

                              children: [
                                TextSpan(
                                  text: 'Since this is a parent account, you can only be added to sports and club chats and your account isn\'t discoverable otherwise. Chats will appear here once you\'re added to them. If this is a mistake, ',
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                    text: 'logout',
                                    style: TextStyle(color: Color(0xff3e5aeb)),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        logout();
                                      }
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final room = snapshot.data![index];

                    return GestureDetector(
                      onTap: () {
                        reachedEndOfChat(room);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              room: room,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 12.0),
                                child: Stack(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        reachedEndOfChat(room);
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => ChatPage(
                                              room: room,
                                            ),
                                          ),
                                        );
                                      },
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(room.imageUrl ?? ''),
                                        backgroundColor: Colors.white,
                                        radius: 30.0,
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: _verifiedIcon(room.metadata?['chatType'] ?? ''),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: EdgeInsets.only(left: 6.0, right: 6.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[


                                        _verifiedText(room.metadata?['chatType'] ?? '', room.name),

                                        Container(
                                          margin: EdgeInsets.only(top: 4.0),
                                          child: _latestMessage(room)
                                        ),
                                      ],
                                    )),
                              ),
                              Column(
                                children: <Widget>[
                                  _latestMessageAgo(room),
                                  _messagesUnread(room, _user!),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

var messagesUnread;
var lastSeenTimestamp;
Widget _messagesUnread(types.Room room, User user) {
  return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('rooms')
          .doc('${room.id}')
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return _UnreadIndicator(-1);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _UnreadIndicator(messagesUnread ?? 0);
        }

        Map<String, dynamic> dataMap = snapshot.data?.data() as Map<String, dynamic>; //When in doubt, use a hashmap :D
        if (dataMap.containsKey('lastMessages')){
          lastSeenTimestamp = dataMap.containsKey('lastSeen') ? dataMap['lastSeen']['${user.uid}'] : '';
          return StreamBuilder(
            stream: FirebaseFirestore.instance.collection('rooms/${room.id}/messages').where('createdAt', isGreaterThanOrEqualTo: lastSeenTimestamp).limit(100).snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot2){

              if (snapshot.hasError) {
                return _UnreadIndicator(-1);
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return _UnreadIndicator(messagesUnread ?? 0);
              }

              if (snapshot2.hasData){
                Map<String, dynamic> dataMap2 = snapshot.data!.data() as Map<String, dynamic>; //When in doubt, use a hashmap :D
                messagesUnread = snapshot2.data.docs.length;
              }

              return _UnreadIndicator(messagesUnread);

            }
          );
        }
        else {
          messagesUnread = 0;
        }
        return _UnreadIndicator(messagesUnread);
      });
}



class _UnreadIndicator extends StatelessWidget {
  final unread;

  _UnreadIndicator(this.unread);

  @override
  Widget build(BuildContext context) {
    if (unread == 0 || unread == null) {
      return Container(); // return empty container
    } else {
      return Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 30,
                color: unread == -1 ? Colors.red : Color(0xff3e5aeb),
                width: unread == -1 ? 60 : 30,
                padding: EdgeInsets.all(0),
                alignment: Alignment.center,
                child: Text(
                  unread > 99 ? '>99' : unread == -1 ? 'ERROR' : unread.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              )));
    }
  }
}
