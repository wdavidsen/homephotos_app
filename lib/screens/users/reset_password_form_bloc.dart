import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:homephotos_app/models/api_exception.dart';
import 'package:homephotos_app/models/password_change.dart';
import 'package:homephotos_app/models/password_reset.dart';
import 'package:homephotos_app/screens/custom_field_bloc_validators.dart';
import 'package:homephotos_app/services/homephotos_service.dart';
import 'package:homephotos_app/services/user_store_service.dart';

class ResetPasswordFormBloc extends FormBloc<String, String> {
  final HomePhotosService _homePhotosService = GetIt.I.get();

  String selectedUsername;

  final newPassword = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      CustomFieldBlocValidators.passwordMin8Chars,
    ],
  );

  final newPasswordConfirm = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      CustomFieldBlocValidators.passwordMin8Chars,
    ],
  );

  ResetPasswordFormBloc() : super(isLoading: false, isEditing: true) {
    addFieldBlocs(
      fieldBlocs: [
        newPassword,
        newPasswordConfirm,
      ],
    );

  newPasswordConfirm
    ..addValidators([FieldBlocValidators.confirmPassword(newPassword)])
    ..subscribeToFieldBlocs([newPassword]);
  }

  @override
  void onSubmitting() async {
    try {
      final resetInfo = PasswordReset(
        username: selectedUsername,
        newPassword: newPassword.value,
        newPasswordCompare: newPasswordConfirm.value
      );
      _homePhotosService.resetPassword(resetInfo);

      emitSuccess(successResponse: "Password reset successfully");
    }
    on ApiException catch (e) {
      emitFailure(failureResponse: e.message);
    }
    catch (e) {
      emitFailure(failureResponse: 'Failed to reset password');
    }
  }
}