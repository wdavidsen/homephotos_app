import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:homephotos_app/models/api_exception.dart';
import 'package:homephotos_app/models/registration.dart';
import 'package:homephotos_app/models/service_info.dart';
import 'package:homephotos_app/models/user.dart';
import 'package:homephotos_app/models/user_settings.dart';
import 'package:homephotos_app/services/homephotos_service.dart';
import 'package:homephotos_app/services/user_settings_service.dart';

class RegisterFormBloc extends FormBloc<String, String> {
  final HomePhotosService _homePhotosService = GetIt.I.get();
  final UserSettingsService _userSettingsService = GetIt.I.get();

  final serviceUrl = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final username = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  final password = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.passwordMin6Chars,
    ],
  );

  final email = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.email,
    ],
  );

  final firstName = TextFieldBloc();

  final lastName = TextFieldBloc();

  RegisterFormBloc() {
    addFieldBlocs(
      step: 0,
      fieldBlocs: [serviceUrl],
    );
    addFieldBlocs(
      step: 1,
      fieldBlocs: [username, password],
    );
    addFieldBlocs(
      step: 2,
      fieldBlocs: [email, firstName, lastName],
    );
  }

  @override
  void onSubmitting() async {
    if (state.currentStep == 0) {

      // try {
      //   if (await _homePhotosService.pingService(serviceUrl.value)) {
      //     emitSuccess();
      //   }
      //   emitFailure();
      // }
      // on ApiException catch (e) {
      //   emitFailure(failureResponse: e.message);
      // }
      // catch (e) {
      //   emitFailure(failureResponse: "Unexpected error");
      // }

      emitSuccess();
    }
    else if (state.currentStep == 1) {

      // try {
      //   if (await _homePhotosService.checkUsername(username.value)) {
      //     emitSuccess();
      //   }
      //   emitFailure();
      // }
      // on ApiException catch (e) {
      //   emitFailure(failureResponse: e.message);
      // }
      // catch (e) {
      //   emitFailure(failureResponse: "Unexpected error");
      // }

      emitSuccess();
    }
    else if (state.currentStep == 2) {
      var reg = Registration(
        username: username.value,
        password: password.value,
        passwordCompare: password.value,
        firstName: firstName.value,
        lastName: lastName.value
      );

      try {
        _homePhotosService.register(reg);
        emitSuccess(successResponse: "Registration successful");
        await _persistService(serviceUrl.value);
      }
      on ApiException catch (e) {
        emitFailure(failureResponse: e.message);
      }
      catch (e) {
        emitFailure(failureResponse: "Unexpected error");
      }
    }
  }

  void _persistService(String serviceUrl) async {
    var settings = _userSettingsService.getSettings();

    if (settings.services.any((s) => s.serviceUrl == serviceUrl)) {
      settings.services.add(ServiceInfo(serviceName: serviceUrl, serviceUrl: serviceUrl));
    }
    _userSettingsService.saveSettings(settings);
  }
}