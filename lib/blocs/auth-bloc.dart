import 'package:homephotos_app/bloc/bloc.dart';
import 'package:homephotos_app/models/tokens.dart';
import 'package:homephotos_app/models/user.dart';

class AuthBloc extends Bloc {
  static User _currentUser;

  AuthBloc();

  static bool isLoggedIn() {
    return _currentUser.jwt != null;
  }

  static User getCurrentUser() {
    return _currentUser;
  }

  static User setCurrentUser(User user) {
    _currentUser = user;
  }

  static void updateTokens(Tokens tokens) {
    _currentUser.jwt = tokens.jwt;
    _currentUser.refreshToken = tokens.refreshToken;
  }
}