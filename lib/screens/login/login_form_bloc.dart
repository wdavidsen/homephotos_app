import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:homephotos_app/services/homephotos_service.dart';
import 'package:homephotos_app/services/navigator_service.dart';
import 'package:homephotos_app/services/user_settings_service.dart';
import 'package:homephotos_app/services/user_store_service.dart';

class LoginFormBloc extends FormBloc<String, String> {
  final HomePhotosService _homePhotosService = GetIt.I.get();
  final UserStoreService _userStore = GetIt.I.get();
  final NavigatorService _navService = GetIt.I.get();
  final UserSettingsService _userSettingsService = GetIt.I.get();

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

  final services = SelectFieldBloc<String, Object>(
    items: []
  );

  LoginFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        username,
        password,
        services
      ],
    );
  }

  @override
  void onLoading() async {
    try {
      final settings = await _userSettingsService.getSettings();
      if (settings?.services != null) {
        settings.services.forEach((item) => services.addItem(item));
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
      var user = await _homePhotosService.login(username.value, password.value);
      _userStore.setCurrentUser(user);
      emitSuccess();
    }
    catch (ex) {
      emitFailure(failureResponse: 'Sign-in failed');
    }
  }
}