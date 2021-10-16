import 'package:flutter/material.dart';

const kBackGroundColor = Color(0xff101115);
const kAppbarColor = Color(0xff10151e);
const kCardColor = Color(0xff273031);

const defaultAvatarImg =
    'https://firebasestorage.googleapis.com/v0/b/twitter-clone-69d19.appspot.com/o/defaultImage%2FPikPng.com_profile-icon-png_805523.png?alt=media&token=5e034ac1-f36d-48fe-b03b-ff34bc26b1e0';

final Shader linearGradient = LinearGradient(
  colors: <Color>[
    Color(0xff4ca3dd),
    Color(0xff4ca3dd),
    Color(0xffdfa7f1),
    Color(0xfff0eec7),
    Color(0xffa6e5e1),
    Color(0xffff7450),
  ],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 30.0));
