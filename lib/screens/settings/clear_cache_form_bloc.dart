import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:homephotos_app/services/homephotos_service.dart';

class ClearCacheFormBloc extends FormBloc<String, String> {
  final HomePhotosService _homePhotosService = GetIt.I.get();

  ClearCacheFormBloc() : super(isLoading: false, isEditing: true) {
    addFieldBlocs(
      fieldBlocs: [],
    );
  }

  @override
  void onSubmitting() async {
    try {
      _homePhotosService.clearCache();
      emitSuccess(successResponse: "Cache clearing triggered successfully");
    }
    catch (e) {
      emitFailure(failureResponse: "Failed to trigger cache clearing");
    }
  }
}