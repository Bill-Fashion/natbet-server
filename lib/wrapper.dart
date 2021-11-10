import 'package:flutter/material.dart';
import 'package:natbet/screens/main_screens/home.dart';
import 'package:natbet/screens/main_screens/room.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: Colors.red,
        primaryColorDark: Colors.red,
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        // Color(0xFF212121),
        dividerColor: Colors.black12,
      ),
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
