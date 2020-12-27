import 'dart:async';
import 'dart:convert';
import 'package:homephotos_app/models/tag.dart';
import 'package:homephotos_app/models/tag_state.dart';
import 'package:homephotos_app/services/service_helper.dart';
import 'package:http/http.dart' as http;

import '../app_config.dart';

class TagsService {

  static Future<List<Tag>> getTags() async {
    final response = await http.get(
      "${AppConfig.apiUrl}/tags",
      headers: ServiceHelper.secureHeaders,
    );

    List<Tag> tags = json.decode(response.body);
    return tags;
  }

  static Future<List<Tag>> searchTags(String keywords) async {
    final response = await http.get(
      "${AppConfig.apiUrl}/tags/search?keywords=${Uri.encodeComponent(keywords)}",
      headers: ServiceHelper.secureHeaders,
    );

    List<Tag> tags = json.decode(response.body);
    return tags;
  }

  static Future<Tag> addTag(Tag tag) async {
    final response = await http.post(
      "${AppConfig.apiUrl}/tags",
      headers: ServiceHelper.secureHeaders,
      body: tag
    );

    Tag t = json.decode(response.body);
    return t;
  }

  static Future<Tag> updateTag(Tag tag) async {
    final response = await http.put(
      "${AppConfig.apiUrl}/tags",
      headers: ServiceHelper.secureHeaders,
      body: tag
    );

    Tag t = json.decode(response.body);
    return t;
  }

  static Future<void> deleteTag(int tagId) async {
    await http.delete(
      "${AppConfig.apiUrl}/tags/${tagId}",
      headers: ServiceHelper.secureHeaders,
    );
  }

  static Future<Tag> copyTag(int sourceTagId, String newTagName) async {
    final response = await http.put(
      "${AppConfig.apiUrl}/tags/copy",
      headers: ServiceHelper.secureHeaders,
      body: { "SourceTagId": sourceTagId, "newTagName": newTagName },
    );

    Tag tag = json.decode(response.body);
    return tag;
  }

  static Future<Tag> mergeTags(List<int> sourceTagIds, String newTagName) async {
    final response = await http.put(
      "${AppConfig.apiUrl}/tags/merge",
      headers: ServiceHelper.secureHeaders,
      body: { "sourceTagIds": sourceTagIds, "newTagName": newTagName }
    );

    Tag tag = json.decode(response.body);
    return tag;
  }

  static Future<List<TagState>> getPhotoTags(List<int> photoIds) async {
    final response = await http.post(
      "${AppConfig.apiUrl}/tags/batchTag}",
      headers: ServiceHelper.secureHeaders,
      body: photoIds
    );

    List<TagState> tagStates = json.decode(response.body);
    return tagStates;
  }

  static Future<Tag> updatePhotoTags(List<int> photoIds, List<TagState> tagStates) async {
    await http.put(
        "${AppConfig.apiUrl}/tags/batchTag",
        headers: ServiceHelper.secureHeaders,
        body: { "photoIds": photoIds, "tagStates": tagStates }
    );
  }
}