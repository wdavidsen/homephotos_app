import 'dart:async';
import 'dart:convert';
import 'package:homephotos_app/models/settings.dart';
import 'package:homephotos_app/services/service_helper.dart';
import 'package:http/http.dart' as http;

import '../app_config.dart';

class SettingsService {
  static Future<Settings> getSettings() async {
    http.Response response = await http.get(
      "${AppConfig.apiUrl}/settings",
      headers: ServiceHelper.secureHeaders,
    );

    var settings = Settings.fromJson(json.decode(response.body));
    return settings;
  }

  static Future<void> updateSettings(Settings user, bool reprocessPhotos) async {
    var url = "${AppConfig.apiUrl}/settings";

    if (reprocessPhotos) {
      url += '?reprocessPhotos=true';
    }
    await http.put(url,
        headers: ServiceHelper.secureHeaders,
        body: user
    );
  }
}