import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:homephotos_app/services/auth_service.dart';

class Login1FormBloc extends FormBloc<String, String> {
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

  Login1FormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        username,
        password,
      ],
    );
  }

  @override
  void onSubmitting() async {
    print(username.value);
    print(password.value);

    try {
      await AuthService.login(username.value, password.value);
      emitSuccess();
    }
    catch (ex) {
      emitFailure(failureResponse: 'This is an awesome error!');
    }
  }
}