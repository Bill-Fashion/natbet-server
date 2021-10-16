import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:natbet/screens/auth_screens/sign_up.dart';
import 'package:natbet/services/auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LoginScreen> {
  // final AuthService _authService = AuthService();
  String email = '';
  String password = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: 50,
          child: TextFormField(
            key: _formKey,
            onChanged: (val) => setState(() {
              email = val;
            }),
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                // border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.white38,
                ),
                hintText: 'username/email',
                hintStyle: TextStyle(color: Colors.white38)),
          ),
        )
      ],
    );
  }

  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: 50,
          child: TextFormField(
            onChanged: (val) => setState(() {
              password = val;
            }),
            obscureText: true,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                // border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.white38,
                ),
                hintText: 'password',
                hintStyle: TextStyle(color: Colors.white38)),
          ),
        ),
      ],
    );
  }

  Widget signInButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async => {AuthService().signIn(email, password)},
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.red,
          elevation: 5,
          padding: EdgeInsets.all(15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(70)),
        ),
        child: Text(
          "Sign In",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget signUpButton() {
    return Container(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignUpScreen()));
        },
        child: Text(
          "Sign up for Retttiwt",
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: GestureDetector(
        child: Stack(
          children: <Widget>[
            Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomCenter,
                        colors: [Colors.red, Colors.black, Colors.black])),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Form(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              buildEmail(),
                              buildPassword(),
                              signInButton(),
                              signUpButton()
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    ));
  }
}
