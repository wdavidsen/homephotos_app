import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:homephotos_app/models/settings.dart';
import 'package:homephotos_app/services/home_photos_service.dart';

class SettingsFormBloc extends FormBloc<String, String> {
  final HomePhotosService _homePhotosService = GetIt.I.get();

  final photosFolder = TextFieldBloc();
  final cacheFolder = TextFieldBloc();
  final mobileUploadsFolder = TextFieldBloc();
  final indexDateTime = InputFieldBloc<DateTime, Object>();
  final indexFrequency = TextFieldBloc<int>();
  final thumbPhotoSize = TextFieldBloc<int>();
  final largePhotoSize = TextFieldBloc<int>();
  final smallPhotoSize = TextFieldBloc<int>();

  final text = TextFieldBloc();
  final select = SelectFieldBloc<String, dynamic>();

  SettingsFormBloc() : super(isLoading: true, isEditing: true) {
    addFieldBlocs(
      fieldBlocs: [photosFolder,
        cacheFolder,
        mobileUploadsFolder,
        indexDateTime,
        indexFrequency,
        thumbPhotoSize,
        largePhotoSize,
        smallPhotoSize,
        text,
        select,
      ],
    );
  }

  @override
  void onLoading() async {
    try {
      var settings = await _homePhotosService.settingsGet();

      if (settings != null) {

        photosFolder.updateValue(settings.indexPath);
        cacheFolder.updateValue(settings.cacheFolder);
        mobileUploadsFolder.updateValue(settings.mobileUploadsFolder);
        indexDateTime.updateValue(settings.nextIndexTime);
        indexFrequency.updateValue(settings.indexFrequencyHours.toString());
        thumbPhotoSize.updateValue(settings.thumbnailSize.toString());
        largePhotoSize.updateValue(settings.largeImageSize.toString());
        smallPhotoSize.updateValue(settings.smallImageSize.toString());
      }

      // await Future<void>.delayed(Duration(milliseconds: 1500));

      //   // Simulate network error
      //   throw Exception('Network request failed. Please try again later.');

      // text.updateInitialValue('I am prefilled');
      //
      // select
      //   ..updateItems(['Option A', 'Option B', 'Option C'])
      //   ..updateInitialValue('Option B');

      emitLoaded();
    }
    catch (e) {
      emitLoadFailed();
    }
  }

  @override
  void onSubmitting() async {

    try {
      var settings = Settings(
          indexPath: photosFolder.value,
          cacheFolder: cacheFolder.value,
          mobileUploadsFolder: mobileUploadsFolder.value,
          nextIndexTime: indexDateTime.value,
          indexFrequencyHours: indexFrequency.valueToInt,
          smallImageSize: smallPhotoSize.valueToInt,
          largeImageSize: largePhotoSize.valueToInt,
          thumbnailSize: thumbPhotoSize.valueToInt,
        );
      _homePhotosService.settingsUpdate(settings, false);
      emitSuccess();
    }
    catch (e) {
      emitFailure();
    }
  }

  void indexNow() {
    print('indexing now');
  }

  void clearCache() {
    print('clearing cache');
  }
}