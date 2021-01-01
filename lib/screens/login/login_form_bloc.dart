import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:homephotos_app/services/homephotos_service.dart';
import 'package:homephotos_app/services/user_store_service.dart';

class LoginFormBloc extends FormBloc<String, String> {
  final HomePhotosService _homePhotosService = GetIt.I.get();
  final UserStoreService _userStore = GetIt.I.get();

  final username = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final password = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  LoginFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        username,
        password,
      ],
    );
  }

  @override
  void onSubmitting() async {
    try {
      var user = await _homePhotosService.login(username.value, password.value);
      _userStore.setCurrentUser(user);
      emitSuccess();
    }
    catch (ex) {
      emitFailure(failureResponse: 'Sign-in failed');
    }
  }
}