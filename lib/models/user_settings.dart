import 'package:meta/meta.dart';

class UserSettings {
  String thumbnailSize;
  String slideshowSpeed;
  bool autoStartSlideshow;

  UserSettings({
    @required this.thumbnailSize,
    @required this.slideshowSpeed,
    @required this.autoStartSlideshow
  });

  UserSettings.fromJson(Map<String, dynamic> json)
    : thumbnailSize = json['thumbnailSize'],
      slideshowSpeed = json['slideshowSpeed'],
      autoStartSlideshow = json['autoStartSlideshow'];

  Map<String, dynamic> toJson() =>
    {
      'thumbnailSize': thumbnailSize,
      'slideshowSpeed': slideshowSpeed,
      'autoStartSlideshow': autoStartSlideshow,
    };
}