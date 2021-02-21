import 'dart:async';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:homephotos_app/models/photo.dart';
import 'package:homephotos_app/services/homephotos_service.dart';

class PhotosFormBloc extends FormBloc<String, String> {
  final HomePhotosService _homePhotosService = GetIt.I.get();
  final StreamController<List<Photo>> _photosSubject = StreamController<List<Photo>>();

  String selectedTagName;

  Stream<List<Photo>> get photos => _photosSubject.stream;
  Sink<List<Photo>> get photosSink => _photosSubject.sink;

  String baseImageUrl;

  PhotosFormBloc() : super(isLoading: true, isEditing: false) {
    this.baseImageUrl = _homePhotosService.getPhotoUrl();
  }

  @override
  void onLoading() async {
    try {
      final photos = (selectedTagName != null)
          ? await _homePhotosService.photosGetByTag(1, this.selectedTagName)
          : await _homePhotosService.photosGetLatest(1);
      photosSink.add(photos);
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
    _photosSubject.close();
  }
}