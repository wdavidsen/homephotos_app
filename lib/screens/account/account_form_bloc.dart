import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:homephotos_app/models/account_info.dart';
import 'package:homephotos_app/models/api_exception.dart';
import 'package:homephotos_app/services/homephotos_service.dart';
import 'package:homephotos_app/services/navigator_service.dart';

class AccountFormBloc extends FormBloc<String, String> {
  final HomePhotosService _homePhotosService = GetIt.I.get();
  final NavigatorService _navService = GetIt.I.get();

  AccountInfo _accountInfo;

  final username = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );
  final firstName = TextFieldBloc();
  final lastName = TextFieldBloc();

  AccountFormBloc() : super(isLoading: true, isEditing: true) {
    addFieldBlocs(
      fieldBlocs: [username,
        firstName,
        lastName,
      ],
    );
  }

  @override
  void onLoading() async {
    try {
      await _homePhotosService.loadCsrfToken();
      _accountInfo = await _homePhotosService.accountGet();

      if (_accountInfo != null) {
        username.updateValue(_accountInfo.username);
        firstName.updateValue(_accountInfo.firstName);
        lastName.updateValue(_accountInfo.lastName);
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
      _accountInfo.username = username.value;
      _accountInfo.firstName = firstName.value;
      _accountInfo.lastName = lastName.value;

      await _homePhotosService.accountUpdate(_accountInfo);
      emitSuccess(successResponse: "Account saved successfully");
    }
    on ApiException catch (e) {
      emitFailure(failureResponse: e.message);
    }
    catch (e) {
      emitFailure(failureResponse: 'Failed to save account info');
    }
  }

  void logout() async {
    await _homePhotosService.logout();
    _navService.navigateToLogin();
  }
}
