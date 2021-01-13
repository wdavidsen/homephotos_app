import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:homephotos_app/components/loading_dialog.dart';
import 'package:homephotos_app/screens/settings/clear_cache_form_bloc.dart';
import 'package:homephotos_app/screens/settings/index_now_form_bloc.dart';

class ClearCacheFormScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClearCacheFormBloc(),
      child: Builder(
        builder: (context) {
          final clearCacheFormBloc = context.bloc<ClearCacheFormBloc>();

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(title: Text('Photo Cache')),
            body: FormBlocListener<ClearCacheFormBloc, String, String>(
              onSubmitting: (context, state) {
                LoadingDialog.show(context);
              },
              onSuccess: (context, state) {
                LoadingDialog.hide(context);
                Navigator.of(context).pop();
              },
              onFailure: (context, state) {
                LoadingDialog.hide(context);
                Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.failureResponse)));
              },
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Are you sure you want to reset the your photo cache?",
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.black87
                        ),
                      ),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: clearCacheFormBloc.submit,
                          color: Colors.blue,
                            child: Text(
                            'OK',
                            style: TextStyle(
                              color: Colors.white
                            )
                          ),
                        ),
                        RaisedButton(
                          onPressed: () => { Navigator.of(context).pop() },
                          child: Text('Cancel'),
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