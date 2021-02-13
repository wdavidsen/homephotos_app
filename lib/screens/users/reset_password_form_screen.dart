import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:homephotos_app/components/loading_dialog.dart';
import 'package:homephotos_app/screens/users/reset_password_form_bloc.dart';

class ResetPasswordFormScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordFormBloc(),
      child: Builder(
        builder: (context) {
          final changePasswordFormBloc = context.bloc<ResetPasswordFormBloc>();

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(title: Text('Reset Password')),
            body: FormBlocListener<ResetPasswordFormBloc, String, String>(
              onSubmitting: (context, state) {
                LoadingDialog.show(context);
              },
              onSuccess: (context, state) {
                LoadingDialog.hide(context);

                Navigator.of(context).pop();
              },
              onFailure: (context, state) {
                LoadingDialog.hide(context);

                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text(state.failureResponse)));
              },
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    TextFieldBlocBuilder(
                      textFieldBloc: changePasswordFormBloc.newPassword,
                      suffixButton: SuffixButton.obscureText,
                      decoration: InputDecoration(
                        labelText: 'New password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    TextFieldBlocBuilder(
                      textFieldBloc: changePasswordFormBloc.newPasswordConfirm,
                      suffixButton: SuffixButton.obscureText,
                      decoration: InputDecoration(
                        labelText: 'New password (confirm)',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    RaisedButton(
                      onPressed: changePasswordFormBloc.submit,
                      color: Colors.blue,
                      child: Text(
                          'Reset Now',
                          style: TextStyle(
                              color: Colors.white
                          )
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}