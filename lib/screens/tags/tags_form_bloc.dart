import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:homephotos_app/models/tag.dart';
import 'package:homephotos_app/services/homephotos_service.dart';

class TagsFormBloc extends FormBloc<String, String> {
  final HomePhotosService _homePhotosService = GetIt.I.get();
  final StreamController<List<Tag>> _tagsSubject = StreamController<List<Tag>>();

  Stream<List<Tag>> get tags => _tagsSubject.stream;
  Sink<List<Tag>> get tagsSink => _tagsSubject.sink;

  TagsFormBloc() : super(isLoading: true, isEditing: false) {}

  @override
  void onLoading() async {
    try {
      final tags = await _homePhotosService.tagsGet();
      tagsSink.add(tags);
      emitLoaded();
    }
    catch (e) {
      emitLoadFailed();
    }
  }

  @override
  void onSubmitting() {
  }

  void dispose() {
    _tagsSubject.close();
  }
}