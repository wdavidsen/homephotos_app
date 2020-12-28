
import 'package:homephotos_app/bloc/bloc.dart';
import 'package:homephotos_app/models/settings.dart';
import 'package:homephotos_app/services/settings_service.dart';
import 'package:rxdart/rxdart.dart';

class SettingsBloc extends Bloc {

  SettingsBloc() {
    // load();
  }

  final _cacheFolder = BehaviorSubject<String>();
  final _mobileUploadsFolder = BehaviorSubject<String>();
  final _indexPath = BehaviorSubject<String>();
  final _nextIndexTime = BehaviorSubject<DateTime>();
  final _indexFrequencyHours = BehaviorSubject<int>();
  final _smallImageSize = BehaviorSubject<int>();
  final _largeImageSize = BehaviorSubject<int>();
  final _thumbnailSize = BehaviorSubject<int>();

  // Observable<String> get cacheFolder => _cacheFolder.stream;
  // Observable<String> get mobileUploadsFolder => _mobileUploadsFolder.stream;
  // Observable<String> get indexPath => _indexPath.stream;
  // Observable<DateTime> get nextIndexTime => _nextIndexTime.stream;
  // Observable<int> get indexFrequencyHours => _indexFrequencyHours.stream;
  // Observable<int> get smallImageSize => _smallImageSize.stream;
  // Observable<int> get largeImageSize => _largeImageSize.stream;
  // Observable<int> get thumbnailSize => _thumbnailSize.stream;

  Function(String) get changeCacheFolder => _cacheFolder.sink.add;
  Function(String) get changeMobileUploadsFolder => _mobileUploadsFolder.sink.add;
  Function(String) get changeIndexPath => _indexPath.sink.add;
  Function(DateTime) get changeNextIndexTime => _nextIndexTime.sink.add;
  Function(int) get changeIndexFrequencyHours => _indexFrequencyHours.sink.add;
  Function(int) get changeSmallImageSize => _smallImageSize.sink.add;
  Function(int) get changeLargeImageSize => _largeImageSize.sink.add;
  Function(int) get changeThumbnailSize => _thumbnailSize.sink.add;

  void dispose() async {
    await _cacheFolder.drain();
    _cacheFolder.close();

    await _mobileUploadsFolder.drain();
    _mobileUploadsFolder.close();

    await _indexPath.drain();
    _indexPath.close();

    await _nextIndexTime.drain();
    _nextIndexTime.close();

    await _indexFrequencyHours.drain();
    _indexFrequencyHours.close();

    await _smallImageSize.drain();
    _smallImageSize.close();

    await _largeImageSize.drain();
    _largeImageSize.close();

    await _thumbnailSize.drain();
    _thumbnailSize.close();
  }

  bool validateFields() {
    if (_cacheFolder.value != null &&
        _cacheFolder.value.isNotEmpty &&
        _indexPath.value != null &&
        _indexPath.value.isNotEmpty) {

      return true;
    }
    else {
      return false;
    }
  }

  Future<void> load() async {
    var settings = await SettingsService.getSettings();

    if (settings != null) {
      _indexPath.add(settings.indexPath);
      _cacheFolder.add(settings.cacheFolder);
      _mobileUploadsFolder.add(settings.mobileUploadsFolder);
      _indexFrequencyHours.add(settings.indexFrequencyHours);
      _smallImageSize.add(settings.smallImageSize);
      _largeImageSize.add(settings.largeImageSize);
      _thumbnailSize.add(settings.thumbnailSize);
    }
  }

  Future<bool> submit() async {
    try {
      var settings = Settings(
        indexPath: _indexPath.value,
        cacheFolder: _cacheFolder.value,
        mobileUploadsFolder: _mobileUploadsFolder.value,
        nextIndexTime: _nextIndexTime.value,
        indexFrequencyHours: _indexFrequencyHours.value,
        smallImageSize: _smallImageSize.value,
        largeImageSize: _largeImageSize.value,
        thumbnailSize: _thumbnailSize.value
      );
      await SettingsService.updateSettings(settings, false);
      return true;
    }
    catch (error) {
      return false;
    }
  }
}