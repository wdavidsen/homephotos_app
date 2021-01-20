import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:homephotos_app/models/user.dart';
import 'package:homephotos_app/services/homephotos_service.dart';

class UsersFormBloc extends FormBloc<String, String> {
  final HomePhotosService _homePhotosService = GetIt.I.get();
  final StreamController<List<User>> _usersSubject = StreamController<List<User>>();

  Stream<List<User>> get users => _usersSubject.stream;
  Sink<List<User>> get usersSink => _usersSubject.sink;

  UsersFormBloc() : super(isLoading: true, isEditing: false) {}

  @override
  void onLoading() async {
    try {
      final users = await _homePhotosService.usersGet();
      usersSink.add(users);
      emitLoaded();
    }
    catch (e) {
      emitLoadFailed();
    }
  }

  @override
  void onSubmitting() {
  }

  void dispose() {
    _usersSubject.close();
  }
}