import 'dart:convert';

import 'package:homephotos_app/models/service_info.dart';

class UserSettings {
  List<ServiceInfo> services;
  String thumbnailSize;
  String slideshowSpeed;
  String currentServiceUrl;
  bool autoStartSlideshow;

  UserSettings({
    this.thumbnailSize,
    this.slideshowSpeed,
    this.autoStartSlideshow
  }) {
    this.services = [];
    this.currentServiceUrl = null;
  }

  UserSettings.fromJson(Map<String, dynamic> map) {
    thumbnailSize = map['thumbnailSize'];
    slideshowSpeed = map['slideshowSpeed'];
    autoStartSlideshow = map['autoStartSlideshow'];
    currentServiceUrl = map['currentServiceUrl'];

    if (map['services'] != null) {
      services = List<ServiceInfo>();

      try {
        map['services'].forEach((v) {
          services.add(ServiceInfo.fromJson(v));
        });
      }
      catch (e) {
        print("Failed to deserialize services.");
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['thumbnailSize'] = this.thumbnailSize;
    data['slideshowSpeed'] = this.slideshowSpeed;
    data['autoStartSlideshow'] = this.autoStartSlideshow;
    data['currentServiceUrl'] = this.currentServiceUrl;

    if (this.services != null) {
      data['services'] = this.services.map((v) => v.toJson()).toList();
    }
    return data;
  }
}