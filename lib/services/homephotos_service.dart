import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:homephotos_app/app_config.dart';
import 'package:homephotos_app/models/account_info.dart';
import 'package:homephotos_app/models/api_exception.dart';
import 'package:homephotos_app/models/password_change.dart';
import 'package:homephotos_app/models/photo.dart';
import 'package:homephotos_app/models/settings.dart';
import 'package:homephotos_app/models/tag.dart';
import 'package:homephotos_app/models/tag_state.dart';
import 'package:homephotos_app/models/tokens.dart';
import 'package:homephotos_app/models/user.dart';
import 'package:homephotos_app/services/navigator_service.dart';
import 'package:homephotos_app/services/user_store_service.dart';

import 'cookie_store_service.dart';

class HomePhotosService {
  final Dio api = Dio();
  final UserStoreService _userStore = GetIt.I.get();
  final CookieStoreService _cookieStore = GetIt.I.get();

  final String XSRF_Request_Token = 'XSRF-REQUEST-TOKEN';
  final String XSRF_Token = '.AspNetCore.Antiforgery';

  HomePhotosService() {
    api.interceptors.add(InterceptorsWrapper(
        onRequest: (options) async {
          options.headers['content-type'] = 'application/json';
          options.headers['accept'] = 'application/json';
          final tokens = await _userStore.getTokens();
          if (tokens != null) {
            final token = tokens.jwt;
            options.headers['Authorization'] = 'Bearer $token';
          }
          return options;
        },
        onError: (error) async {
          if (error.response?.statusCode == 401) {
            if (!error.request.uri.path.endsWith('auth/refresh')) {
              print('Updating token with refresh token');
              if (await _refreshExpiredToken()) {
                return _retry(error.request);
              }
              else {
                final NavigatorService _navService = GetIt.I.get();
                _navService.navigateTo('/login', true);
              }
            }
          }
          return error.response;
        }
      ));

    api.interceptors.add(InterceptorsWrapper(
        onRequest: (options) async {
          if (options.method == 'POST' || options.method == 'PUT') {
            var csrfCookie = _cookieStore.getCookie(XSRF_Token);
            var csrfRequestCookie = _cookieStore.getCookie(XSRF_Request_Token);

            if (csrfCookie.isNotEmpty && csrfRequestCookie.isNotEmpty) {
              csrfCookie = csrfCookie.split('; ')[0];
              options.headers['cookie'] = csrfCookie;
              print('Set CSRF cookie to: ${csrfCookie}');

              csrfRequestCookie = csrfRequestCookie.split('; ')[0].split('=')[1];
              options.headers['x-xsrf-token'] = csrfRequestCookie;
              print('Set CSRF request header token to: ${csrfRequestCookie}');
            }
          }
        },
        onResponse: (options) async {
          if (options.request.method == 'GET') {
            final cookies = options.headers.map['set-cookie'] as List<String>;

            if (cookies != null && cookies.isNotEmpty) {
              cookies.forEach((value) {
                if (value.startsWith(XSRF_Token)) {
                  print('Lifted cookie: ${value}');
                  _cookieStore.setCookie(XSRF_Token, value);
                }
                else if (value.startsWith(XSRF_Request_Token)) {
                  print('Lifted cookie: ${value}');
                  _cookieStore.setCookie(XSRF_Request_Token, value);
                }
              });
            }
          }
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
      await _userStore.setCurrentUser(user);
      return user;
    }
    on DioError catch (e, s) {
      print(s);
      _handleError(e);
    }
  }

  Future<User> loginWithPasswordChange(PasswordChange changeInfo) async {
    final url = '${AppConfig.apiUrl}/auth/login';
    final payload = json.encode(changeInfo.toJson());

    try {
      final response = await this.api.post(url, data: payload);
      final user = User.fromJson(response.data);
      await _userStore.setCurrentUser(user);
      return user;
    }
    on DioError catch (e) {
      _handleError(e);
    }
  }

  Future logout() async {
    final url = '${AppConfig.apiUrl}/auth/logout';
    final payload = json.encode({
      "refreshToken": _userStore.getTokens().refreshToken
    });

    try {
      await this.api.post(url, data: payload);
      await _userStore.clearCurrentUser();
    }
    on DioError catch (e) {
      _handleError(e);
    }
  }

  Future loadCsrfToken() async {
    final url = "${AppConfig.apiUrl}/antiforgery";

    try {
      await this.api.get(url);
    }
    catch (e) {
      print('Loading CSRF cookie failed. ' + e.toString());
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

  Future<AccountInfo> accountUpdate(AccountInfo accountInfo) async {
    final url = "${AppConfig.apiUrl}/account";

    try {
      final response = await this.api.put(url, data: accountInfo.toJson());
      _handleNonSuccessStatus(response);
      final info = AccountInfo.fromJson(response.data);
      return info;
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

  void _handleNonSuccessStatus(Response response) {
    if (response.statusCode > 299 || response.statusCode < 200) {
      try {
        var ex = ApiException.fromJson(response.data);
        throw ex;
      }
      catch (e) {
        throw Exception('Server returned error success code.');
      }
    }
  }

  void _handleError(dynamic error) {
    throw error;
  }

  Future<bool> _refreshExpiredToken() async {
    final url = "${AppConfig.apiUrl}/auth/refresh";
    final tokens = await _userStore.getTokens();

    final response = await this.api.post(url, data: { "jwt": tokens.jwt, "refreshToken": tokens.refreshToken });

    if (response.statusCode != 200) {
      print('Failed to update token');
      return false;
    }

    await _userStore.updateTokens(Tokens.fromJson(response.data));
    print('Successfully updated token');
    return true;
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
}