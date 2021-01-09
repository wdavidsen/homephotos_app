import 'package:get_it/get_it.dart';
import 'package:homephotos_app/models/tokens.dart';
import 'package:homephotos_app/models/user.dart';
import 'package:homephotos_app/services/secure_storage_service.dart';

class UserStoreService {
  final String _userKey = 'HOMEPHOTOS_USER';
  User _currentUser;
  SecureStorageService _secureStorage;

  UserStoreService() {
    _secureStorage = GetIt.I.get();
    Future.wait([_loadUser()]);
  }

  bool isLoggedIn() {
    return _currentUser?.jwt != null;
  }

  User getCurrentUser() {
    return _currentUser;
  }

  Future setCurrentUser(User user) async {
    await _secureStorage.write(_userKey, user.toJsonString());
    _currentUser = user;
  }

  Future clearCurrentUser() async {
    await _secureStorage.write(_userKey, null);
    _currentUser = null;
  }

  Future updateTokens(Tokens tokens) async {
    final user = await getCurrentUser();
    await _secureStorage.write(_userKey, user.toJsonString());
    _currentUser.jwt = tokens.jwt;
    _currentUser.refreshToken = tokens.refreshToken;
  }

  Tokens getTokens() {
    return _currentUser != null ? Tokens(jwt: _currentUser.jwt, refreshToken: _currentUser.refreshToken) : null;
  }

  Future _loadUser() async {
    try {
      final value = await _secureStorage.read(_userKey);

      if (value != null) {
        _currentUser = User.fromJsonString(value);
      }
    }
    catch (ex) {
      print('Failed to load user from secure storage.');
    }
  }
}