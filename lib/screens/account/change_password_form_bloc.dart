import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:homephotos_app/models/api_exception.dart';
import 'package:homephotos_app/models/password_change.dart';
import 'package:homephotos_app/screens/custom_field_bloc_validators.dart';
import 'package:homephotos_app/services/homephotos_service.dart';
import 'package:homephotos_app/services/user_store_service.dart';

class ChangePasswordFormBloc extends FormBloc<String, String> {
  final HomePhotosService _homePhotosService = GetIt.I.get();
  final UserStoreService _userStoreService = GetIt.I.get();

  final password = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      CustomFieldBlocValidators.passwordMin8Chars,
    ],
  );

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

  ChangePasswordFormBloc() : super(isLoading: false, isEditing: true) {
    addFieldBlocs(
      fieldBlocs: [password,
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
      final user = _userStoreService.getCurrentUser();
      final changeInfo = PasswordChange(
        username: user.username,
        currentPassword: password.value,
        newPassword: newPassword.value,
        newPasswordCompare: newPasswordConfirm.value
      );
      final tokens = await _homePhotosService.changePassword(changeInfo);
      _userStoreService.updateTokens(tokens);

      emitSuccess(successResponse: "Password changed successfully");
    }
    on ApiException catch (e) {
      emitFailure(failureResponse: e.message);
    }
    catch (e) {
      emitFailure(failureResponse: 'Failed to change password');
    }
  }
}