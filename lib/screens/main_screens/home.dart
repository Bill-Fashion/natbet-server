import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:natbet/models/notification.dart';
import 'package:natbet/models/user.dart';
import 'package:natbet/screens/main_screens/room.dart';
import 'package:natbet/services/auth.dart';
import 'package:natbet/services/local_notification.dart';
import 'package:natbet/services/room.dart';
import 'package:natbet/services/user.dart';
import 'package:natbet/widgets/alert_dialog.dart';
import 'package:natbet/widgets/build_drawer.dart';
import 'package:natbet/widgets/create_room.dart';
import 'package:intl/intl.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  UserService _userService = UserService();
  // late String _token;
  Future<void> saveToken() async {
    // Get the token each time the application loads
    String? token = await FirebaseMessaging.instance.getToken();

    // Save the initial token to the database
    await _userService.saveTokenToDatabase(token);

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh
        .listen(_userService.saveTokenToDatabase);
  }

  @override
  void initState() {
    super.initState();

    saveToken();
    LocalNotificationService.initialize(context);

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        Map<String, dynamic> data = message.data;

        NotificationModel notificationContents =
            NotificationModel.fromMap(jsonDecode(data['notification']));

        LocalNotificationService.display(notificationContents);
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Map<String, dynamic> data = message.data;

      NotificationModel notificationContents =
          NotificationModel.fromMap(jsonDecode(data['notification']));

      LocalNotificationService.display(notificationContents);
    });
  }

  final _picker = new ImagePicker();
  late File _avatarImgUrl;

  Future getImageCam() async {
    final pickedCam = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedCam != null) {
        _avatarImgUrl = File(pickedCam.path);

        _userService.saveAvatar(_avatarImgUrl);
      }
    });
  }

  Future getImageGallery() async {
    final pickedGallery = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedGallery != null) {
        _avatarImgUrl = File(pickedGallery.path);

        _userService.saveAvatar(_avatarImgUrl);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RoomService _roomService = RoomService();
    final authService = Provider.of<AuthService>(context, listen: false);

    return MultiProvider(
      providers: [
        StreamProvider(
          create: (_) => _roomService.getRooms(),
          initialData: null,
        ),
      ],
      child: StreamBuilder(
          stream:
              _userService.getUserInfo(FirebaseAuth.instance.currentUser!.uid),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            UserModel user = UserModel(
                id: snapshot.data['uid'],
                name: snapshot.data['name'],
                email: snapshot.data['email'],
                avatarURL: snapshot.data['avatar'],
                coins: snapshot.data['coins']);
            var formatter = NumberFormat('###,###,###,###');

            return Scaffold(
              endDrawer: BuildDrawer(),
              floatingActionButton: SpeedDial(
                spacing: 5,
                spaceBetweenChildren: 10,
                animatedIcon: AnimatedIcons.menu_close,
                children: [
                  SpeedDialChild(
                      child: Icon(
                        Icons.post_add_rounded,
                      ),
                      label: 'Create room',
                      backgroundColor: Colors.blue,
                      onTap: () async {
                        await CreateRoomDialog()
                            .showRoomCreationDialog(context);
                      }),
                  SpeedDialChild(
                    child: Icon(
                      Icons.logout_rounded,
                    ),
                    label: 'Log out',
                    backgroundColor: Colors.red,
                    onTap: () {
                      _showDialog(context, authService);
                    },
                  ),
                ],
              ),
              backgroundColor: Color.fromRGBO(26, 29, 33, 1),
              appBar: AppBar(
                actions: [drawerIconBuilder()],
                elevation: 0,
                backgroundColor: Colors.red.withOpacity(0.55),
              ),
              body: Container(
                // padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 110,
                          width: double.infinity,
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.55),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(60),
                              bottomRight: Radius.circular(60),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            _buildPopupDialog(context),
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.teal[400],
                                      backgroundImage:
                                          NetworkImage("${user.avatarURL}"),
                                    ),
                                  ),
                                ),
                              ),
                              // SizedBox(height: 15),
                              Flexible(
                                flex: 6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          flex: 3,
                                          child: Text('${user.name}',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: IconButton(
                                              onPressed: () {
                                                showEnterNameDialog(
                                                    context, _userService);
                                              },
                                              icon:
                                                  Icon(Icons.create_outlined)),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: Image.asset(
                                                "assets/icons/coin-stack.png",
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 4,
                                          child: Text(
                                              '${formatter.format(user.coins)}',
                                              maxLines: 2,
                                              style: TextStyle(fontSize: 20)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text('Friends', style: TextStyle(fontSize: 22)),
                    SizedBox(height: 15),
                    //users avatar
                    Container(
                      height: 75,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Column(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white24),
                                    borderRadius: BorderRadius.circular(25)),
                                child: Icon(CupertinoIcons.add),
                              ),
                              SizedBox(height: 5),
                              Text('Add')
                            ],
                          ),
                          SizedBox(width: 18),
                          // UserAvatar(
                          //   id: 1,
                          //   name: 'Nicole',
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rooms',
                          style: TextStyle(fontSize: 22),
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(18)),
                            child: DropdownButton<int>(
                              value: 0,
                              underline: Container(),
                              items: [
                                DropdownMenuItem(value: 0, child: Text('Today'))
                              ],
                              onChanged: (val) {},
                            ))
                      ],
                    ),

                    StreamBuilder<QuerySnapshot>(
                        stream: _roomService.getRooms(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> roomSnapshot) {
                          if (roomSnapshot.hasError) {
                            return Text('Something went wrong');
                          }

                          if (roomSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text("Loading");
                          }

                          return ListView(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            children: roomSnapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;
                              var roomDocId = document.id;

                              List<String> members =
                                  List<String>.from(data['members']);
                              return StreamBuilder<dynamic>(
                                  stream: _userService
                                      .getUserInfo("${data['creator']}"),
                                  builder: (context, userSnapshot) {
                                    if (!userSnapshot.hasData) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                    return GestureDetector(
                                      onTap: () => {
                                        if (data['password'] == null)
                                          {
                                            _userService
                                                .addUserToRoom(roomDocId),
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RoomScreen(
                                                            roomDocId:
                                                                roomDocId)))
                                          },
                                        if (data['password'] != null)
                                          {
                                            if (members.contains(FirebaseAuth
                                                .instance.currentUser!.uid))
                                              {
                                                _userService
                                                    .addUserToRoom(roomDocId),
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            RoomScreen(
                                                                roomDocId:
                                                                    roomDocId)))
                                              }
                                            else
                                              {
                                                showEnterPasswordDialog(context,
                                                    data['password'], roomDocId)
                                              }
                                          }
                                      },
                                      child: Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        color: Color.fromRGBO(26, 29, 33, 1),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                flex: 5,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "${data['roomName']}",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16),
                                                      ),
                                                      Text(
                                                        "Host: ${userSnapshot.data['name']}",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color:
                                                                Colors.white54),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Row(
                                                        children: [
                                                          Text(
                                                              "Room code: ${data['rid']}"),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              if (data['password'] == null)
                                                Flexible(
                                                  flex: 1,
                                                  child: Icon(CupertinoIcons
                                                      .lock_open_fill),
                                                )
                                              else
                                                Flexible(
                                                  flex: 1,
                                                  child: Icon(
                                                    CupertinoIcons.lock_fill,
                                                  ),
                                                )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            }).toList(),
                          );
                        })
                    // ListRooms()
                  ],
                ),
              ),
            );
          }),
    );
  }

  drawerIconBuilder() {
    return Builder(
      builder: (context) => IconButton(
        icon: Icon(CupertinoIcons.chart_bar_square),
        onPressed: () => Scaffold.of(context).openEndDrawer(),
      ),
    );
  }

  _showDialog(BuildContext context, AuthService authService) {
    VoidCallback continueCallBack = () => {
          authService.signOut(),
          // Navigator.of(context).pop(),
        };
    BlurryDialog alert = BlurryDialog(
        title: "Log out",
        content: "Are you sure you want to log out",
        continueCallBack: continueCallBack);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  Future<void> showEnterNameDialog(
      BuildContext context, UserService _userService) async {
    String newName = '';
    return await showDialog(
        context: context,
        builder: (context) {
          final TextEditingController _nameTextEditingController =
              TextEditingController();

          return AlertDialog(
            backgroundColor: Color.fromRGBO(26, 29, 33, 1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            content: Form(
                key: _formKey1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nameTextEditingController,
                      validator: (value) {
                        return value != '' ? null : "Name can't be empty";
                      },
                      onChanged: ((value) => setState(() => newName = value)),
                      decoration: InputDecoration(hintText: "Enter name"),
                    ),
                  ],
                )),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  // Do something like updating SharedPreferences or User Settings etc.
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  if (_formKey1.currentState!.validate()) {
                    // Do something like updating SharedPreferences or User Settings etc.

                    Navigator.pop(context);
                    _userService.changeUserName(newName);
                  }
                },
              ),
            ],
          );
        });
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      backgroundColor: Color.fromRGBO(26, 29, 33, 1),
      // title: const Text('Popup example'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextButton(
              onPressed: () => [getImageCam(), Navigator.pop(context)],
              child: Text(
                "Image from camera",
              )),
          TextButton(
              onPressed: () => [getImageGallery(), Navigator.pop(context)],
              child: Text(
                "Image from library",
              )),
        ],
      ),
    );
  }

  Future<void> showEnterPasswordDialog(
      BuildContext context, String password, String roomDocId) async {
    String? roomPassword = '';
    return await showDialog(
        context: context,
        builder: (context) {
          final TextEditingController _nameTextEditingController =
              TextEditingController();

          return AlertDialog(
            backgroundColor: Color.fromRGBO(26, 29, 33, 1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            content: Form(
                key: _formKey2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nameTextEditingController,
                      validator: (value) {
                        return password == value ? null : "Wrong password";
                      },
                      onChanged: ((value) =>
                          setState(() => roomPassword = value)),
                      decoration: InputDecoration(hintText: "Password"),
                    ),
                  ],
                )),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  // Do something like updating SharedPreferences or User Settings etc.
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  if (_formKey2.currentState!.validate()) {
                    // Do something like updating SharedPreferences or User Settings etc.

                    Navigator.pop(context);
                    _userService.addUserToRoom(roomDocId);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                RoomScreen(roomDocId: roomDocId)));
                  }
                },
              ),
            ],
          );
        });
  }
}
