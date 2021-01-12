import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class ServiceFieldBloc extends GroupFieldBloc {
  final TextFieldBloc serviceName;
  final TextFieldBloc serviceUrl;

  ServiceFieldBloc({
    @required this.serviceName,
    @required this.serviceUrl,
    String name,
  }) : super([serviceName, serviceUrl], name: name);
}