import 'package:natbet/models/user.dart';

class RoomModel {
  String? creator;
  String? rname;
  String? rpassword;
  int? rid;
  List<UserModel>? members;

  RoomModel({this.creator, this.rname, this.rpassword, this.rid, this.members});

  RoomModel.fromJson(Map<String, Object?> json)
      : this(
          creator: json['creator']! as String,
          rname: json['roomName']! as String,
          rpassword: json['password']! as String,
          rid: json['rid']! as int,
          members: json['members']! as List<UserModel>,
        );

  Map<String, Object?> toJson() {
    return {
      'creator': creator,
      'roomName': rname,
      'password': rpassword,
      'rid': rid,
      'members': members,
    };
  }
}
