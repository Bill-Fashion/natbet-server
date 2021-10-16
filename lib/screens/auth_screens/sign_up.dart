import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:natbet/models/user.dart';
import 'package:natbet/services/auth.dart';
import 'package:natbet/services/toast.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  // final AuthService _authService = new AuthService();

  String name = '';
  String email = '';
  String password = '';

  var errorMsg = '';
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    AuthService _authService = AuthService();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: GestureDetector(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              // decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //         begin: Alignment.topLeft,
              //         end: Alignment.bottomCenter,
              //         colors: [Colors.red, Colors.black, Colors.black])),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // textDirection: TextDirection.ltr,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    // Image.asset("assets/images/retttiwt-logo-name.png"),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text(
                            "Sign up for ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            child: Text(
                              "Natbet",
                              style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                  // foreground: Paint()..shader = linearGradient,
                                  ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.centerLeft,
                        height: 50,
                        child: TextFormField(
                          onChanged: (val) => setState(() {
                            name = val;
                          }),
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              // border: InputBorder.none,
                              contentPadding: EdgeInsets.only(top: 14),
                              hintText: 'name',
                              hintStyle: TextStyle(color: Colors.white38)),
                        )),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.centerLeft,
                        height: 50,
                        child: TextFormField(
                          onChanged: (val) => setState(() {
                            email = val;
                          }),
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              // border: InputBorder.none,
                              contentPadding: EdgeInsets.only(top: 14),
                              hintText: 'username/email',
                              hintStyle: TextStyle(color: Colors.white38)),
                        )),

                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.centerLeft,
                        height: 60,
                        child: TextFormField(
                          onChanged: (val) => setState(() {
                            password = val;
                          }),
                          obscureText: true,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              // border: InputBorder.none,
                              contentPadding: EdgeInsets.only(top: 14),
                              hintText: 'password',
                              hintStyle: TextStyle(color: Colors.white38)),
                        )),

                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 25),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async => [
                          if (name == '')
                            {Toast().showToast('"name" are required')}
                          else
                            {
                              _authService.signUp(name, email, password),
                              if (user?.id != null)
                                {
                                  Navigator.pop(context),
                                },
                            }
                        ],
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          padding: EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(70)),
                          onSurface: Color(0xff4ca3dd),
                        ),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
