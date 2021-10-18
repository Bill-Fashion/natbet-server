import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:natbet/models/user.dart';
import 'package:natbet/services/auth.dart';
import 'package:natbet/wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {}

          if (snapshot.connectionState == ConnectionState.done) {
            return StreamProvider<UserModel?>.value(
              value: AuthService().user,
              initialData: UserModel(),
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                darkTheme: ThemeData(
                    primarySwatch: Colors.red,
                    // visualDensity: VisualDensity.adaptivePlatformDensity,
                    brightness: Brightness.dark),
                home: Wrapper(),
              ),
            );
          }
          return CircularProgressIndicator();
        });
  }
}
