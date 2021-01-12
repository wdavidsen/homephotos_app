class ServiceInfo {
  String serviceName;
  String serviceUrl;

  ServiceInfo({this.serviceName, this.serviceUrl});

  ServiceInfo.fromJson(Map<String, dynamic> json) {
    serviceName = json['serviceName'];
    serviceUrl = json['serviceUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['serviceName'] = this.serviceName;
    data['serviceUrl'] = this.serviceUrl;

    return data;
  }
}