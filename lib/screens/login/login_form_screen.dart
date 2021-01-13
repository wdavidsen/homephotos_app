import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:homephotos_app/components/loading_dialog.dart';
import 'package:homephotos_app/models/service_info.dart';
import 'package:homephotos_app/screens/settings/settings_form_screen.dart';

import 'login_form_bloc.dart';

class LoginFormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginFormBloc(),
      child: Builder(
        builder: (context) {
          final loginFormBloc = context.bloc<LoginFormBloc>();

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(title: Text('Sign-In')),
            body: FormBlocListener<LoginFormBloc, String, String>(
              onSubmitting: (context, state) {
                LoadingDialog.show(context);
              },
              onSuccess: (context, state) {
                LoadingDialog.hide(context);

                Navigator.of(context).pushReplacementNamed("/settings");
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
                    DropdownFieldBlocBuilder<ServiceInfo>(
                      selectFieldBloc: loginFormBloc.services,
                      decoration: InputDecoration(
                        labelText: 'Service',
                        prefixIcon: Icon(Icons.api),
                      ),
                      itemBuilder: (context, item) => item.serviceName,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: loginFormBloc.submit,
                            color: Colors.blue,
                            child: Text(
                              'Sign-In',
                              style: TextStyle(
                                color: Colors.white
                              )
                            ),
                          ),
                          RaisedButton(
                            onPressed: () => Navigator.of(context).pushNamed("/register"),
                            child: Text('Register...'),
                          ),
                          RaisedButton(
                            onPressed: () => Navigator.of(context).pushNamed("/services"),
                            child: Text('Services...'),
                          ),
                        ]
                    )
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