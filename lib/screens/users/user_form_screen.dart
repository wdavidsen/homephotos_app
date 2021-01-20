import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:homephotos_app/components/error_retry_message.dart';
import 'package:homephotos_app/components/loading_dialog.dart';
import 'package:homephotos_app/models/role.dart';
import 'package:homephotos_app/screens/users/user_form_bloc.dart';

class UserFormScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final int userId = ModalRoute.of(context).settings.arguments;

    return BlocProvider(
      create: (context) => UserFormBloc(),
      child: Builder(
        builder: (context) {
          final userFormBloc = BlocProvider.of<UserFormBloc>(context);
          userFormBloc.selectedUserId = userId;

          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Scaffold(
              appBar: AppBar(title: Text('User Details')),
              body: FormBlocListener<UserFormBloc, String, String>(
                onSubmitting: (context, state) {
                  LoadingDialog.show(context);
                },
                onSuccess: (context, state) {
                  LoadingDialog.hide(context);
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.successResponse)));

                  Future.delayed(const Duration(milliseconds: 2000), () {
                    Navigator.of(context).pushReplacementNamed("/users");
                  });
                },
                onFailure: (context, state) {
                  LoadingDialog.hide(context);
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.failureResponse)));
                },
                onDeleteFailed: (context, state) {
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.failureResponse)));
                },
                onDeleteSuccessful: (context, state) {
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.successResponse)));

                  Future.delayed(const Duration(milliseconds: 2000), () {
                    Navigator.of(context).pushReplacementNamed("/users");
                  });
                },
                child: BlocBuilder<UserFormBloc, FormBlocState>(
                  buildWhen: (previous, current) => previous.runtimeType != current.runtimeType || previous is FormBlocLoading && current is FormBlocLoading,
                  builder: (context, state) {

                    if (state is FormBlocLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    else if (state is FormBlocLoadFailed) {
                      return ErrorRetryMessage.build(context, userFormBloc.reload, state.failureResponse);
                    }
                    else {
                      return SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              TextFieldBlocBuilder(
                                textFieldBloc: userFormBloc.username,
                                readOnly: userId != null,
                                decoration: InputDecoration(
                                  labelText: 'User id',
                                  prefixIcon: Icon(Icons.person),
                                ),
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: userFormBloc.password,
                                readOnly: userId != null,
                                suffixButton: SuffixButton.obscureText,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock),
                                ),
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: userFormBloc.firstName,
                                decoration: InputDecoration(
                                  labelText: 'First name',
                                ),
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: userFormBloc.lastName,
                                decoration: InputDecoration(
                                  labelText: 'Last name',
                                ),
                              ),
                              DropdownFieldBlocBuilder<Role>(
                                selectFieldBloc: userFormBloc.roles,
                                decoration: InputDecoration(
                                  labelText: 'Role',
                                ),
                                itemBuilder: (context, item) => item.name,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    RaisedButton(
                                      onPressed: userFormBloc.submit,
                                      color: Colors.blue,
                                      child: Text(
                                          'Save',
                                          style: TextStyle(
                                              color: Colors.white
                                          )
                                      ),
                                    ),
                                    RaisedButton(
                                      onPressed: userFormBloc.delete,
                                      color: Colors.blue,
                                      child: Text(
                                          'Delete',
                                          style: TextStyle(
                                              color: Colors.white
                                          )
                                      ),
                                    ),
                                    RaisedButton(
                                      onPressed: () => {},
                                      child: Text('Reset Password'),
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