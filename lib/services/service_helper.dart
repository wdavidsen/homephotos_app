
import 'package:homephotos_app/blocs/auth-bloc.dart';

class ServiceHelper {
  static Map<String, String> nonsecureHeaders = {
    "content-type" : "application/json",
    "accept" : "application/json"
  };

  static Map<String, String> secureHeaders = {
    "content-type" : "application/json",
    "accept" : "application/json",
    "authorization": "bearer ${AuthBloc.getCurrentUser()?.jwt}"
  };
}