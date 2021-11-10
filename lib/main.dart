import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:natbet/screens/auth_screens/login.dart';
import 'package:natbet/screens/main_screens/home.dart';
import 'package:natbet/screens/main_screens/room.dart';
import 'package:natbet/services/auth.dart';
import 'package:natbet/wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          lazy: false,
          create: (_) => AuthService(),
        ),
        // Provider<MessageDao>(
        //   lazy: false,
        //   create: (_) => MessageDao(),
        // ),
      ],
      child: MaterialApp(
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
        home: Consumer<AuthService>(
          builder: (context, user, child) {
            if (user.isLoggedIn()) {
              return Wrapper();
            } else {
              return LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
