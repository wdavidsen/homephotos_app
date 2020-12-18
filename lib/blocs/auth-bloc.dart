import 'package:homephotos_app/bloc/bloc.dart';
import 'package:homephotos_app/models/tokens.dart';
import 'package:homephotos_app/models/user.dart';
import 'package:homephotos_app/services/auth_service.dart';

class AuthBloc extends Bloc {
  static User _currentUser;

  AuthBloc();

  Future<bool> login(String username, String password) async {

    try {
      _currentUser = await AuthService.login(username, password);
      return true;
    }
    catch (error) {
      return false;
    }
  }

  bool isLoggedIn() {
    return _currentUser.jwt != null;
  }

  User getCurrentUser() {
    return _currentUser;
  }

  void updateTokens(Tokens tokens) {
    _currentUser.jwt = tokens.jwt;
    _currentUser.refreshToken = tokens.refreshToken;
  }
}