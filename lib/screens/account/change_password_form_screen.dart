import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:homephotos_app/components/loading_dialog.dart';
import 'package:homephotos_app/screens/account/change_password_form_bloc.dart';

class ChangePasswordFormScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangePasswordFormBloc(),
      child: Builder(
        builder: (context) {
          final loginFormBloc = context.bloc<ChangePasswordFormBloc>();

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(title: Text('Change Password')),
            body: FormBlocListener<ChangePasswordFormBloc, String, String>(
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
                      textFieldBloc: loginFormBloc.password,
                      suffixButton: SuffixButton.obscureText,
                      decoration: InputDecoration(
                        labelText: 'Current password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    TextFieldBlocBuilder(
                      textFieldBloc: loginFormBloc.newPassword,
                      suffixButton: SuffixButton.obscureText,
                      decoration: InputDecoration(
                        labelText: 'New password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    TextFieldBlocBuilder(
                      textFieldBloc: loginFormBloc.newPasswordConfirm,
                      suffixButton: SuffixButton.obscureText,
                      decoration: InputDecoration(
                        labelText: 'New password (confirm)',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    RaisedButton(
                      onPressed: loginFormBloc.submit,
                      color: Colors.blue,
                      child: Text(
                          'Change Now',
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