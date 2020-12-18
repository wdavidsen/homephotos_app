import 'dart:async';
import 'package:homephotos_app/bloc/bloc.dart';
import 'package:homephotos_app/services/auth_service.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends Bloc {
  final _username = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _isSignedIn = BehaviorSubject<bool>();

  LoginBloc();

  Observable<String> get username => _username.stream.transform(_validateUsername);
  Observable<String> get password => _password.stream.transform(_validatePassword);
  Observable<bool> get signInStatus => _isSignedIn.stream;

  Function(String) get changeUsername => _username.sink.add;
  Function(String) get changePassword => _password.sink.add;
  Function(bool) get showProgressBar => _isSignedIn.sink.add;

  final _validateUsername = StreamTransformer<String, String>.fromHandlers(handleData: (username, sink) {
    //if (username.contains('@')) {
      sink.add(username);
    //}
    //else {
      //sink.addError('Invalid username');
    //}
  });

  final _validatePassword = StreamTransformer<String, String>.fromHandlers(handleData: (password, sink) {
    if (password.length > 7) {
      sink.add(password);
    }
    else {
      sink.addError('Invalid password');
    }
  });

  void dispose() async {
    await _username.drain();
    _username.close();

    await _password.drain();
    _password.close();

    await _isSignedIn.drain();
    _isSignedIn.close();
  }

  bool validateFields() {
    if (_username.value != null &&
        _username.value.isNotEmpty &&
        _password.value != null &&
        _password.value.isNotEmpty &&
        _password.value.length > 3) {

      return true;
    }
    else {
      return false;
    }
  }

  Future<bool> submit() async {
    try {
      var user = await AuthService.login(_username.value, _password.value);
      return true;
    }
    catch (error) {
      return false;
    }
  }
}