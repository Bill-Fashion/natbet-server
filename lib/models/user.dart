// import 'package:flutter/src/widgets/framework.dart';

class UserModel {
  final String? id;
  final String? avatarURL;
  final String? name;
  final String? email;
  final String? description;
  final int? coins;
  final List<dynamic>? tokens;

  UserModel(
      {this.coins,
      this.avatarURL,
      this.id,
      this.name,
      this.email,
      this.description,
      this.tokens});
  UserModel.fromMap(Map<String, dynamic> map)
      : id = map['uid'],
        coins = map['coins'],
        name = map['name'],
        avatarURL = map['avatar'],
        email = map['email'],
        description = map['description'],
        tokens = map['tokens'];

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['title'],
      email: json['email'],
      id: json['uid'],
      description: json['description'],
      coins: json['coins'],
      avatarURL: json['avatar'],
      tokens: json['tokens'],
    );
  }
}
