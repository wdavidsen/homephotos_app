import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:homephotos_app/components/loading_dialog.dart';
import 'package:homephotos_app/screens/login/success_screen.dart';

import 'login2_form_bloc.dart';

class Login2Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Login2FormBloc(),
      child: Builder(
        builder: (context) {
          final loadingFormBloc = BlocProvider.of<Login2FormBloc>(context);

          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Scaffold(
              appBar: AppBar(title: Text('Loading and Initializing')),
              body: FormBlocListener<Login2FormBloc, String, String>(
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
                child: BlocBuilder<Login2FormBloc, FormBlocState>(
                  buildWhen: (previous, current) =>
                  previous.runtimeType != current.runtimeType ||
                      previous is FormBlocLoading && current is FormBlocLoading,
                  builder: (context, state) {
                    if (state is FormBlocLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is FormBlocLoadFailed) {
                      return Center(
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.sentiment_dissatisfied, size: 70),
                              SizedBox(height: 20),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                alignment: Alignment.center,
                                child: Text(
                                  state.failureResponse ??
                                      'An error has occurred please try again later',
                                  style: TextStyle(fontSize: 25),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: 20),
                              RaisedButton(
                                onPressed: loadingFormBloc.reload,
                                child: Text('RETRY'),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              TextFieldBlocBuilder(
                                textFieldBloc: loadingFormBloc.text,
                                decoration: InputDecoration(
                                  labelText: 'Prefilled text field',
                                  prefixIcon:
                                  Icon(Icons.sentiment_very_satisfied),
                                ),
                              ),
                              RadioButtonGroupFieldBlocBuilder<String>(
                                selectFieldBloc: loadingFormBloc.select,
                                itemBuilder: (context, item) => item,
                                decoration: InputDecoration(
                                  labelText: 'Prefilled select field',
                                  prefixIcon: SizedBox(),
                                ),
                              ),
                              RaisedButton(
                                onPressed: loadingFormBloc.submit,
                                child: Text('SUBMIT'),
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