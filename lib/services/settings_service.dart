import 'dart:async';
import 'package:http/http.dart' as http;

class SettingsService {
  static Future<String> exampleApi(String orgid) async {
    http.Response response = await http.get(
      Uri.encodeFull("https://localhost:44375/api"),
    );
    print("Response ${response.body.toString()}");
    //Returns 'true' or 'false' as a String
    return response.body;
  }
}