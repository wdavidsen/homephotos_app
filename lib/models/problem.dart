class Problem {
  int id;
  String message;

  Problem.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      message = json['message'];

  Map<String, dynamic> toJson() =>
    {
      'id': id,
      'message': message,
    };
}