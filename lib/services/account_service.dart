import 'dart:async';
import 'dart:convert';
import 'package:homephotos_app/app_config.dart';
import 'package:homephotos_app/models/account_info.dart';
import 'package:homephotos_app/models/password_change.dart';
import 'package:homephotos_app/models/tokens.dart';
import 'package:homephotos_app/models/user.dart';
import 'package:homephotos_app/services/service_helper.dart';
import 'package:http/http.dart' as http;

class AccountService {

  static Future<void> register(User user) async {
    await http.post(
        "https://localhost:44375/api/account/register",
        headers: ServiceHelper.nonsecureHeaders,
        body: user
    );
  }

  static Future<Tokens> changePassword(PasswordChange changeInfo) async {
    final response = await http.post(
      "${AppConfig.apiUrl}/account/changePassword",
      headers: ServiceHelper.secureHeaders,
      body: changeInfo
    );

    Tokens tokens = Tokens.fromJson(json.decode(response.body));
    return tokens;
  }

  static Future<AccountInfo> info() async {
    final response = await http.get(
      "${AppConfig.apiUrl}/account",
      headers: ServiceHelper.secureHeaders,
    );

    AccountInfo info = AccountInfo.fromJson(json.decode(response.body));
    return info;
  }

  static Future<void> update(AccountInfo accountInfo) async {
    await http.put(
      "${AppConfig.apiUrl}/account",
      headers: ServiceHelper.secureHeaders,
      body: accountInfo
    );
  }
}

