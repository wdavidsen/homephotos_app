import 'package:homephotos_app/bloc/bloc.dart';

class UsersBloc extends Bloc {

  void dispose() async {
  }

  Future<bool> submit() async {
    try {
      return true;
    }
    catch (error) {
      return false;
    }
  }
}