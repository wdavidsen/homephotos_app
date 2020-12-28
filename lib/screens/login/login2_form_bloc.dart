import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class Login2FormBloc extends FormBloc<String, String> {
  final text = TextFieldBloc();

  final select = SelectFieldBloc<String, dynamic>();

  Login2FormBloc() : super(isLoading: true) {
    addFieldBlocs(
      fieldBlocs: [text, select],
    );
  }

  var _throwException = true;

  @override
  void onLoading() async {
    try {
      await Future<void>.delayed(Duration(milliseconds: 1500));

      // if (_throwException) {
      //   // Simulate network error
      //   throw Exception('Network request failed. Please try again later.');
      // }

      text.updateInitialValue('I am prefilled');

      select
        ..updateItems(['Option A', 'Option B', 'Option C'])
        ..updateInitialValue('Option B');

      emitLoaded();
    }
    catch (e) {
      _throwException = false;

      emitLoadFailed();
    }
  }

  @override
  void onSubmitting() async {
    print(text.value);
    print(select.value);

    try {
      await Future<void>.delayed(Duration(milliseconds: 500));

      emitSuccess();
    }
    catch (e) {
      emitFailure();
    }
  }
}