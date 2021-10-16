import 'package:flutter/material.dart';
import 'package:natbet/models/user.dart';
import 'package:natbet/screens/auth_screens/login.dart';
import 'package:natbet/screens/main_screens/home.dart';
import 'package:natbet/screens/main_screens/room.dart';

import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    // print(user);
    if (user?.id == null) {
      return LoginScreen();
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
          primarySwatch: Colors.red,
          // visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.dark),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/room': (context) => RoomScreen(
              roomDocId: '',
            ),
      },
    );
  }
}
