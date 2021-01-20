  import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:homephotos_app/models/service_group.dart';
import 'package:homephotos_app/models/service_info.dart';
import 'package:homephotos_app/screens/custom_field_bloc_validators.dart';
import 'package:homephotos_app/screens/services/service_field_bloc.dart';
import 'package:homephotos_app/services/user_settings_service.dart';

class ServicesFormBloc extends FormBloc<String, String> {
  final UserSettingsService _userSettingsService = GetIt.I.get();
  final services = ListFieldBloc<ServiceFieldBloc>(name: 'services');

  ServicesFormBloc() : super(isLoading: true, isEditing: true) {
    addFieldBlocs(
      fieldBlocs: [
        services,
      ],
    );
  }

  void addService(String initialServiceName, String initialServiceUrl) {
    services.addFieldBloc(ServiceFieldBloc(
      name: 'service',
      serviceName: TextFieldBloc(
          name: 'serviceName',
          initialValue: initialServiceName,
          validators: [
            FieldBlocValidators.required,
          ],
      ),
      serviceUrl: TextFieldBloc(
          name: 'serviceUrl',
          initialValue: initialServiceUrl,
          validators: [
            FieldBlocValidators.required,
            CustomFieldBlocValidators.https,
          ],
      ),
    ));
  }

  void removeService(int index) {
    services.removeFieldBlocAt(index);
  }

  @override
  void onLoading() async {
    try {
      final settings = _userSettingsService.getSettings();
      if (settings?.services != null) {
        settings.services.forEach((item) => addService(item.serviceName, item.serviceUrl));
      }
      emitLoaded();
    }
    catch (e) {
      print(e);
      emitLoaded();
      //emitLoadFailed();
    }
  }

  @override
  void onSubmitting() async {

    try {
      final serviceGroup = ServiceGroup(
        services: services.value.map<ServiceInfo>((serviceField) {
          return ServiceInfo(
            serviceName: serviceField.serviceName.value,
            serviceUrl: serviceField.serviceUrl.value,
          );
        }).toList(),
      );

      var settings = _userSettingsService.getSettings();
      settings.services = serviceGroup.services;
      await _userSettingsService.saveSettings(settings);
    }
    catch (e) {
      print (e);
      emitFailure(failureResponse: "Failed to save settings");
      return;
    }

    emitSuccess(
      canSubmitAgain: true,
      successResponse: "Successfully updated services",
    );
  }
}
