import 'package:meta/meta.dart';

class Tokens {
  String jwt;
  String refreshToken;

  Tokens({
    this.jwt,
    this.refreshToken
  });

  Tokens.fromJson(Map<String, dynamic> json)
    : jwt = json['jwt'],
      refreshToken = json['refreshToken'];

  Map<String, dynamic> toJson() =>
    {
      'jwt': jwt,
      'refreshToken': refreshToken,
    };
}
