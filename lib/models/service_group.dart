import 'package:homephotos_app/models/service_info.dart';

class ServiceGroup {
  List<ServiceInfo> services;

  ServiceGroup({this.services});

  ServiceGroup.fromJson(Map<String, dynamic> json) {
    if (json['services'] != null) {
      services = List<ServiceInfo>();
      json['services'].forEach((v) {
        services.add(ServiceInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.services != null) {
      data['services'] = this.services.map((v) => v.toJson()).toList();
    }
    return data;
  }
}