import 'package:get_it/get_it.dart';
import 'package:homephotos_app/services/secure_storage_service.dart';

class CookieStoreService {
  Map<String, String> _cookies;
  final String _cookiesKey = 'HOMEPHOTOS_COOKIES';
  final SecureStorageService _secureStorage = GetIt.I.get();

  CookieStoreService()  {
    Future.wait([_loadCookies()]);
  }

  void setCookie(String key, String value) {
    _cookies[key] = value;
    _persistCookies();
  }

  String getCookie(String key) {
    if (_cookies.containsKey(key)) {
      return _cookies[key];
    }
    return null;
  }

  Future _loadCookies() async {
    _cookies = Map<String, String>();
    var cookieStr = await _secureStorage.read(_cookiesKey);

    if (cookieStr != null) {
      cookieStr.split('|').forEach((element) {
        var keyValue = element.split('=');
        _cookies.putIfAbsent(keyValue[0], () => keyValue[1]);
      });
    }
  }

  Future _persistCookies() async {
    var cookieStr = '';

    _cookies.forEach((key, value) {
      cookieStr += '|${key}={value}';
    });

    if (cookieStr.length > 0) {
      cookieStr = cookieStr.substring(1);
    }
    await _secureStorage.write(_cookiesKey, cookieStr);
  }
}