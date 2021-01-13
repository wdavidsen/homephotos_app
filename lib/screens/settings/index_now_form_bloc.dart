import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:homephotos_app/services/homephotos_service.dart';

class IndexNowFormBloc extends FormBloc<String, String> {
  final HomePhotosService _homePhotosService = GetIt.I.get();

  final processNewChangedOnly = BooleanFieldBloc(
    initialValue: true
  );

  IndexNowFormBloc() : super(isLoading: false, isEditing: true) {
    addFieldBlocs(
      fieldBlocs: [
        processNewChangedOnly,
      ],
    );
  }

  @override
  void onSubmitting() async {
    try {
      _homePhotosService.indexNow(!processNewChangedOnly.value);
      emitSuccess(successResponse: "Photo index triggered successfully");
    }
    catch (e) {
      emitFailure(failureResponse: "Failed to trigger photo index");
    }
  }
}