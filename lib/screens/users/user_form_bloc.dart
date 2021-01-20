import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:homephotos_app/models/api_exception.dart';
import 'package:homephotos_app/models/password_user.dart';
import 'package:homephotos_app/models/role.dart';
import 'package:homephotos_app/models/user.dart';
import 'package:homephotos_app/screens/custom_field_bloc_validators.dart';
import 'package:homephotos_app/services/homephotos_service.dart';

class UserFormBloc extends FormBloc<String, String> {
  final HomePhotosService _homePhotosService = GetIt.I.get();
  int selectedUserId;
  List<Role> availableRoles = [
    Role(id: 0, name: 'Reader'),
    Role(id: 1, name: 'Contributer'),
    Role(id: 2, name: 'Admin')];

  User _user;

  final username = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final password = TextFieldBloc(
    validators: [
      CustomFieldBlocValidators.passwordMin8Chars,
    ],
  );

  // final passwordConfirm = TextFieldBloc(
  //   validators: [
  //     CustomFieldBlocValidators.passwordMin8Chars,
  //   ],
  // );

  final firstName = TextFieldBloc();
  final lastName = TextFieldBloc();

  final roles = SelectFieldBloc<Role, Object>(
      items: []
  );

  UserFormBloc() : super(isLoading: true, isEditing: true) {
    addFieldBlocs(
      fieldBlocs: [username,
        password,
        firstName,
        lastName,
        roles,
      ],
    );
  }

  @override
  void onLoading() async {
    try {
      roles.updateItems(this.availableRoles);

      if (this.selectedUserId != null) {
        await _homePhotosService.loadCsrfToken();
        _user = await _homePhotosService.userGet(this.selectedUserId);

        var userRole = this.availableRoles.firstWhere((item) => item.name == _user.role, orElse: () => null);
        roles.updateInitialValue(userRole);

        username.updateValue(_user.username);
        firstName.updateValue(_user.firstName);
        lastName.updateValue(_user.lastName);

        password.updateValue("*********");
      }
      else {
        _user = User();
        password.addValidators([FieldBlocValidators.required]);
      }
      emitLoaded();
    }
    catch (e) {
      emitLoadFailed();
    }
  }

  @override
  void onSubmitting() async {
    try {
      _user.userId = selectedUserId;
      _user.username = username.value;
      _user.firstName = firstName.value;
      _user.lastName = lastName.value;
      _user.role = roles.value.name;

      if (selectedUserId == null) {
        final passwordUser = PasswordUser(user: _user, password: password.value, passwordCompare: password.value);
        final user = await _homePhotosService.userAdd(passwordUser);

        if (user != null && user.userId != null) {
          this.selectedUserId = user.userId;
          password.updateValue("*********");
        }
      }
      else {
        await _homePhotosService.userUpdate(_user);
      }
      emitSuccess(successResponse: "User saved successfully");
    }
    on ApiException catch (e) {
      emitFailure(failureResponse: e.message);
    }
    catch (e) {
      emitFailure(failureResponse: 'Failed to save user');
    }
  }

  @override
  void onDeleting() async {
    try {
      await _homePhotosService.userDelete(_user.userId);
      emitDeleteSuccessful(successResponse: "User deleted successfully");
    }
    on ApiException catch (e) {
      emitDeleteFailed(failureResponse: e.message);
    }
    catch (e) {
      emitDeleteFailed(failureResponse: 'Failed to delete user');
    }
  }
}