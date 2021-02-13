import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:homephotos_app/components/error_retry_message.dart';
import 'package:homephotos_app/components/loading_dialog.dart';
import 'package:homephotos_app/components/main_nav_menu.dart';
import 'package:homephotos_app/screens/account/account_form_bloc.dart';
import 'package:homephotos_app/screens/account/change_password_form_screen.dart';

class AccountFormScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountFormBloc(),
      child: Builder(
        builder: (context) {
          final loadingFormBloc = BlocProvider.of<AccountFormBloc>(context);

          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Scaffold(
              appBar: AppBar(title: Text('Account')),
              drawer: Drawer(
                child: MainNavMenu.build(context),
              ),
              body: FormBlocListener<AccountFormBloc, String, String>(
                onSubmitting: (context, state) {
                  LoadingDialog.show(context);
                },
                onSuccess: (context, state) {
                  LoadingDialog.hide(context);
                },
                onFailure: (context, state) {
                  LoadingDialog.hide(context);

                  Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.failureResponse)));
                },
                child: BlocBuilder<AccountFormBloc, FormBlocState>(
                  buildWhen: (previous, current) => previous.runtimeType != current.runtimeType || previous is FormBlocLoading && current is FormBlocLoading,
                  builder: (context, state) {

                    if (state is FormBlocLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    else if (state is FormBlocLoadFailed) {
                      return ErrorRetryMessage.build(context, loadingFormBloc.reload, state.failureResponse);
                    }
                    else {
                      return SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              TextFieldBlocBuilder(
                                textFieldBloc: loadingFormBloc.username,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: 'User id',
                                ),
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: loadingFormBloc.firstName,
                                decoration: InputDecoration(
                                  labelText: 'First name',
                                ),
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: loadingFormBloc.lastName,
                                decoration: InputDecoration(
                                  labelText: 'Last name',
                                ),
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: loadingFormBloc.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Email address',
                                ),
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    RaisedButton(
                                      onPressed: loadingFormBloc.submit,
                                      color: Colors.blue,
                                      child: Text(
                                        'Save',
                                        style: TextStyle(
                                            color: Colors.white
                                        )
                                      ),
                                    ),
                                    RaisedButton(
                                      onPressed: () => {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChangePasswordFormScreen()))
                                      },
                                      child: Text('Change Password...'),
                                    ),
                                    RaisedButton(
                                      onPressed: loadingFormBloc.logout,
                                      child: Text('Sign-Out'),
                                    ),
                                  ]
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}