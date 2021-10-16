import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoomWidget extends StatelessWidget {
  final String? roomName;
  final int? rid;
  final String? password;
  final String? creator;
  const RoomWidget({
    Key? key,
    required this.roomName,
    required this.rid,
    this.password,
    required this.creator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      margin: EdgeInsets.symmetric(vertical: 6),
      height: 75,
      decoration: BoxDecoration(
          color: Color.fromRGBO(34, 37, 42, 1),
          borderRadius: BorderRadius.circular(18)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$roomName"),
              Text("$creator"),
            ],
          ),
          Icon(CupertinoIcons.lock_fill)
        ],
      ),
    );
  }
}
