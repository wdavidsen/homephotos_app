import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:homephotos_app/app_config.dart';
import 'package:homephotos_app/blocs/auth-bloc.dart';
import 'package:homephotos_app/models/account_info.dart';
import 'package:homephotos_app/models/password_change.dart';
import 'package:homephotos_app/models/photo.dart';
import 'package:homephotos_app/models/settings.dart';
import 'package:homephotos_app/models/tag.dart';
import 'package:homephotos_app/models/tag_state.dart';
import 'package:homephotos_app/models/tokens.dart';
import 'package:homephotos_app/models/user.dart';

class HomePhotosService {
  Dio api;

  HomePhotosService() {
    this.api = Dio();

    api.interceptors.add(InterceptorsWrapper(
        onRequest: (options) async {
          options.headers['content-type'] = 'application/json';
          options.headers['accept'] = 'application/json';
          final token = _getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return options;
        },
        onError: (error) async {
          if (error.response?.statusCode == 401) {
            if (!error.request.uri.path.endsWith('auth/refresh')) {
              print('Updating token with refresh token');
              await _refreshExpiredToken();
              return _retry(error.request);
            }
          }
          return error.response;
        }
      ));
  }

  Future<User> login(String username, String password) async {
    final url = '${AppConfig.apiUrl}/auth/login';
    final payload = json.encode({
      "username": username,
      "password": password
    });

    try {
      final response = await this.api.post(url, data: payload);
      final user = User.fromJson(response.data);
      AuthBloc.setCurrentUser(user);
      return user;
    }
    on DioError catch (e) {
      _handleError(e);
    }
  }

  Future<Settings> settingsGet() async {
    final url = "${AppConfig.apiUrl}/settings";

    try {
      final response = await this.api.get(url);
      final settings = Settings.fromJson(response.data);
      return settings;
    }
    on DioError catch (e) {
      _handleError(e);
    }
  }

  Future<void> settingsUpdate(Settings settings, bool reprocessPhotos) async {
    var url = "${AppConfig.apiUrl}/settings";

    if (reprocessPhotos) {
      url += '?reprocessPhotos=true';
    }

    try {
      await this.api.put(url, data: settings.toJson());
    }
    on DioError catch (e) {
      _handleError(e);
    }
  }

  Future<void> register(User user) async {
    final url = "https://localhost:44375/api/account/register";

    try {
      await this.api.post(url, data: user.toJson());
    }
    on DioError catch (e) {
      _handleError(e);
    }
  }

  Future<Tokens> changePassword(PasswordChange changeInfo) async {
    final url = "${AppConfig.apiUrl}/account/changePassword";

    try {
      final response = await this.api.post(url, data: changeInfo.toJson());
      final tokens = Tokens.fromJson(response.data);
      return tokens;
    }
    on DioError catch (e) {
      _handleError(e);
    }
  }

  Future<AccountInfo> accountGet() async {
    final url = "${AppConfig.apiUrl}/account";

    try {
      final response = await this.api.get(url);
      final accountInfo = AccountInfo.fromJson(response.data);
      return accountInfo;
    }
    on DioError catch (e) {
      _handleError(e);
    }
  }

  Future<void> accountUpdate(AccountInfo accountInfo) async {
    final url = "${AppConfig.apiUrl}/account";

    try {
      final response = await this.api.put(url, data: accountInfo.toJson());
      final tokens = Tokens.fromJson(response.data);
      return tokens;
    }
    on DioError catch (e) {
      _handleError(e);
    }
  }

  Future<List<Photo>> photosGetLatest(int pageNum) async {
    final url = "${AppConfig.apiUrl}/photos/latest?pageNum=${pageNum}";

    try {
      final response = await this.api.get(url);
      // todo: add deserialization
      return null;
    }
    on DioError catch (e) {
      _handleError(e);
    }
  }

  Future<List<Photo>> photosGetByTag(int pageNum, String tagName) async {
    final url = "${AppConfig.apiUrl}/photos/byTag?pageNum=${pageNum}&tag=${Uri.encodeComponent(tagName)}";

    try {
      final response = await this.api.get(url);
      // todo: add deserialization
      return null;
    }
    on DioError catch (e) {
      _handleError(e);
    }
  }

  Future<List<Photo>> photosSearch(int pageNum, String keywords) async {
    final url = "${AppConfig.apiUrl}/photos/search?pageNum=${pageNum}&keywords=${Uri.encodeComponent(keywords)}";

    try {
      final response = await this.api.get(url);
      // todo: add deserialization
      return null;
    }
    on DioError catch (e) {
      _handleError(e);
    }
  }

  Future<Tag> tagAdd(Tag tag) async {
    final url = "${AppConfig.apiUrl}/tags";

    try {
      final response = await this.api.post(url, data: tag.toJson());
      final t = Tag.fromJson(response.data);
      return t;
    }
    on DioError catch (e) {
      _handleError(e);
    }
  }

  Future<Tag> tagUpdate(Tag tag) async {
    final url = "${AppConfig.apiUrl}/tags";

    try {
      final response = await this.api.put(url, data: tag.toJson());
      final t = Tag.fromJson(response.data);
      return t;
    }
    on DioError catch (e) {
      _handleError(e);
    }
  }

  Future<void> tagDelete(int tagId) async {
    final url = "${AppConfig.apiUrl}/tags/${tagId}";

    try {
      await this.api.delete(url);
    }
    on DioError catch (e) {
      _handleError(e);
    }
  }

  Future<Tag> tagCopy(int sourceTagId, String newTagName) async {
    final url = "${AppConfig.apiUrl}/tags/copy";

    try {
      final response = await this.api.put(url, data: { "sourceTagId": sourceTagId, "newTagName": newTagName });
      final t = Tag.fromJson(response.data);
      return t;
    }
    on DioError catch (e) {
      _handleError(e);
    }
  }

  Future<List<Tag>> tagsGet() async {
    final url = "${AppConfig.apiUrl}/tags";

    try {
      final response = await this.api.get(url);
      // todo: add deserialization
      return null;
    }
    on DioError catch (e) {
      _handleError(e);
    }
  }

  Future<List<Tag>> tagsSearch(String keywords) async {
    final url = "${AppConfig.apiUrl}/tags/search?keywords=${Uri.encodeComponent(keywords)}";

    try {
      final response = await this.api.get(url);
      // todo: add deserialization
      return null;
    }
    on DioError catch (e) {
      _handleError(e);
    }
  }

  Future<Tag> tagsMerge(List<int> sourceTagIds, String newTagName) async {
    final url = "${AppConfig.apiUrl}/tags/merge";

    try {
      final response = await this.api.put(url, data: { "sourceTagIds": sourceTagIds, "newTagName": newTagName });
      final t = Tag.fromJson(response.data);
      return t;
    }
    on DioError catch (e) {
      _handleError(e);
    }
  }

  Future<List<TagState>> tagsGetByPhotoIds(List<int> photoIds) async {
    final url = "${AppConfig.apiUrl}/tags/batchTag}";

    try {
      final response = await this.api.post(url, data: photoIds);
      // todo: add deserialization
      return null;
    }
    on DioError catch (e) {
      _handleError(e);
    }
  }

  Future<Tag> tagsUpdatePhotoTags(List<int> photoIds, List<TagState> tagStates) async {
    final url = "${AppConfig.apiUrl}/tags/batchTag";

    try {
      final response = await this.api.put(url, data: { "photoIds": photoIds, "tagStates": tagStates });
      // todo: add deserialization
      return null;
    }
    on DioError catch (e) {
      _handleError(e);
    }
  }

  Future<User> userGet(int userId) async {
    final url = "${AppConfig.apiUrl}/users/$userId";

    try {
      final response = await this.api.get(url);
      final user = User.fromJson(response.data);
      return user;
    }
    on DioError catch (e) {
      _handleError(e);
    }
  }

  Future<User> userAdd(User user) async {
    final url = "${AppConfig.apiUrl}/users";

    try {
      final response = await this.api.post(url, data: user.toJson());
      final u = User.fromJson(response.data);
      return u;
    }
    on DioError catch (e) {
      _handleError(e);
    }
  }

  Future<User> userUpdate(User user) async {
    final url = "${AppConfig.apiUrl}/users";

    try {
      final response = await this.api.put(url, data: user.toJson());
      final u = User.fromJson(response.data);
      return u;
    }
    on DioError catch (e) {
      _handleError(e);
    }
  }

  Future<void> userDelete(int userId) async {
    final url = "${AppConfig.apiUrl}/users/${userId}";

    try {
      await this.api.delete(url);
    }
    on DioError catch (e) {
      _handleError(e);
    }
  }

  Future<List<User>> usersGet() async {
    final url = "${AppConfig.apiUrl}/users";

    try {
      final response = await this.api.get(url);
      List<Map<String, dynamic>> list = response.data;
      var users = List<User>();

      list.forEach((element) {
        users.add(User.fromJson(element));
      });
    }
    on DioError catch (e) {
      _handleError(e);
    }
  }

  void _handleError(DioError error) {
    throw error;
  }

  Future<void> _refreshExpiredToken() async {
    final url = "${AppConfig.apiUrl}/auth/refresh";
    // await this._storage.read(key: 'refreshToken');
    final response = await this.api.post(url, data: { "jwt": _getAccessToken(), "refreshToken": _getRefreshToken() });

    if (response.statusCode != 200) {
      print('Failed to update token');
      return;
    }
    AuthBloc.updateTokens(Tokens.fromJson(response.data));
    print('Successfully updated token');
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = new Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    print('Retrying previous request');

    return this.api.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  String _getAccessToken() {
    return AuthBloc.getCurrentUser()?.jwt;
  }

  String _getRefreshToken() {
    return AuthBloc.getCurrentUser()?.refreshToken;
  }
}