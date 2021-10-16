// import 'package:flutter/material.dart';
// import 'package:natbet/models/room.dart';
// import 'package:natbet/widgets/room_widget.dart';
// import 'package:provider/provider.dart';

// class ListRooms extends StatefulWidget {
//   @override
//   _ListRoomsState createState() => _ListRoomsState();
// }

// class _ListRoomsState extends State<ListRooms> {
//   @override
//   Widget build(BuildContext context) {
//     var rooms = Provider.of<List<RoomModel>?>(context) ?? [];

//     print(rooms);
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: ScrollPhysics(),
//       itemCount: rooms.length,
//       itemBuilder: (context, index) {
//         var room = rooms[index];

//         return RoomWidget(
//           roomName: room.rname,
//           rid: room.rid,
//           creator: room.creator,
//           password: room.rpassword,
//         );
//       },
//     );
//   }
// }
