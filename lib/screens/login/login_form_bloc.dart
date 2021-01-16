import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:homephotos_app/models/service_info.dart';
import 'package:homephotos_app/screens/custom_field_bloc_validators.dart';
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
      CustomFieldBlocValidators.passwordMin8Chars
    ],
  );

  SelectFieldBloc<ServiceInfo, Object> services = SelectFieldBloc<ServiceInfo, Object>(
      items: []
  );

  LoginFormBloc() : super(isLoading: true, isEditing: true) {
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
      final settings = _userSettingsService.getSettings();
      final currentService = settings.services.firstWhere((item) => item.serviceUrl == settings.currentServiceUrl, orElse: () => null);

      services.updateItems(settings.services);

      if (currentService != null) {
        services.updateInitialValue(currentService);
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
      await _userSettingsService.updateCurrentServiceInfo(services.value);
      var user = await _homePhotosService.login(username.value, password.value);
      await _userStore.setCurrentUser(user);

      emitSuccess();
    }
    catch (ex) {
      emitFailure(failureResponse: 'Sign-in failed');
    }
  }
}