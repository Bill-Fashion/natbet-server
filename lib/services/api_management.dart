import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:natbet/models/result_response.dart';

class ApiManagement {
  Future<ResultResponse> setResult(
      String roomId, String gameId, String winner) async {
    // final uri = Uri.http('https://natbet.herokuapp.com', '/result/pay');
    final response = await http.post(
      Uri.parse('https://natbet.herokuapp.com/result/pay'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'roomId': roomId,
        'gameId': gameId,
        'winner': winner
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return ResultResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to reach server.');
    }
  }

  Future<ResultResponse> createNotification(
      String roomId, String description) async {
    // final uri = Uri.http('192.168.1.5:8080', '/notify/push');
    final response = await http.post(
      Uri.parse('https://natbet.herokuapp.com/notify/push'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'roomId': roomId,
        'description': description,
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return ResultResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to reach server.');
    }
  }
}
