class ApiException implements Exception {
  int id;
  String message;

  ApiException.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      message = json['message'];

  Map<String, dynamic> toJson() =>
    {
      'id': id,
      'message': message,
    };
}