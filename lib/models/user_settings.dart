import 'dart:convert';

class UserSettings {
  List<String> services;
  String thumbnailSize;
  String slideshowSpeed;
  bool autoStartSlideshow;

  UserSettings({
    this.thumbnailSize,
    this.slideshowSpeed,
    this.autoStartSlideshow
  }) {
    this.services = [];
  }

  UserSettings.fromJson(Map<String, dynamic> map)
    : services = json.decode(map['services']),
      thumbnailSize = map['thumbnailSize'],
      slideshowSpeed = map['slideshowSpeed'],
      autoStartSlideshow = map['autoStartSlideshow'];

  Map<String, dynamic> toJson() =>
    {
      'services': json.encode(services),
      'thumbnailSize': thumbnailSize,
      'slideshowSpeed': slideshowSpeed,
      'autoStartSlideshow': autoStartSlideshow,
    };
}