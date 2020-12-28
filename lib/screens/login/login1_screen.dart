import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:homephotos_app/components/loading_dialog.dart';
import 'package:homephotos_app/screens/login/success_screen.dart';

import 'login1_form_bloc.dart';

class Login1Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Login1FormBloc(),
      child: Builder(
        builder: (context) {
          final loginFormBloc = context.bloc<Login1FormBloc>();

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(title: Text('Login')),
            body: FormBlocListener<Login1FormBloc, String, String>(
              onSubmitting: (context, state) {
                LoadingDialog.show(context);
              },
              onSuccess: (context, state) {
                LoadingDialog.hide(context);

                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => SuccessScreen()));
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
                      textFieldBloc: loginFormBloc.username,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    TextFieldBlocBuilder(
                      textFieldBloc: loginFormBloc.password,
                      suffixButton: SuffixButton.obscureText,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    RaisedButton(
                      onPressed: loginFormBloc.submit,
                      child: Text('LOGIN'),
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