import 'dart:async';
import 'dart:convert';
import 'package:homephotos_app/models/photo.dart';
import 'package:homephotos_app/services/service_helper.dart';
import 'package:http/http.dart' as http;

import '../app_config.dart';

class PhotosService {

  static Future<List<Photo>> getLatest(int pageNum) async {
    final response = await http.get(
      "${AppConfig.apiUrl}/photos/latest?pageNum=${pageNum}",
      headers: ServiceHelper.secureHeaders,
    );

    List<Photo> photos = json.decode(response.body);
    return photos;
  }

  static Future<List<Photo>> getPhotosByTag(int pageNum, String tagName) async {
    final response = await http.get(
      "${AppConfig.apiUrl}/photos/byTag?pageNum=${pageNum}&tag=${Uri.encodeComponent(tagName)}",
      headers: ServiceHelper.secureHeaders,
    );

    List<Photo> photos = json.decode(response.body);
    return photos;
  }

  static Future<List<Photo>> searchPhotos(int pageNum, String keywords) async {
    final response = await http.get(
      "${AppConfig.apiUrl}/photos/search?pageNum=${pageNum}&keywords=${Uri.encodeComponent(keywords)}",
      headers: ServiceHelper.secureHeaders,
    );

    List<Photo> photos = json.decode(response.body);
    return photos;
  }
}