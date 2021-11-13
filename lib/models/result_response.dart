class ResultResponse {
  final String title;

  ResultResponse({required this.title});

  factory ResultResponse.fromJson(Map<String, dynamic> json) {
    return ResultResponse(
      title: json['message'],
    );
  }
}
