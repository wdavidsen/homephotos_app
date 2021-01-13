import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:homephotos_app/components/error_retry_message.dart';
import 'package:homephotos_app/components/loading_dialog.dart';
import 'package:homephotos_app/components/main_nav_menu.dart';
import 'package:homephotos_app/screens/settings/index_now_form_screen.dart';
import 'package:homephotos_app/screens/settings/settings_form_bloc.dart';

class SettingsFormScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsFormBloc(),
      child: Builder(
        builder: (context) {
          final loadingFormBloc = BlocProvider.of<SettingsFormBloc>(context);

          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Scaffold(
              appBar: AppBar(title: Text('Settings')),
              drawer: Drawer(
                child: MainNavMenu.build(context),
              ),
              body: FormBlocListener<SettingsFormBloc, String, String>(
                onSubmitting: (context, state) {
                  LoadingDialog.show(context);
                },
                onSuccess: (context, state) {
                  LoadingDialog.hide(context);

                  // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SuccessScreen()));
                },
                onFailure: (context, state) {
                  LoadingDialog.hide(context);

                  Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.failureResponse)));
                },
                child: BlocBuilder<SettingsFormBloc, FormBlocState>(
                  buildWhen: (previous, current) =>
                  previous.runtimeType != current.runtimeType ||
                      previous is FormBlocLoading && current is FormBlocLoading,
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
                                textFieldBloc: loadingFormBloc.photosFolder,
                                decoration: InputDecoration(
                                  labelText: 'Photos folder',
                                  prefixIcon: Icon(Icons.folder),
                                ),
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: loadingFormBloc.cacheFolder,
                                decoration: InputDecoration(
                                  labelText: 'Photos index cache folder',
                                  prefixIcon: Icon(Icons.folder),
                                ),
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: loadingFormBloc.mobileUploadsFolder,
                                decoration: InputDecoration(
                                  labelText: 'Mobile uploads folder',
                                  prefixIcon: Icon(Icons.folder),
                                ),
                              ),
                              DateTimeFieldBlocBuilder(
                                dateTimeFieldBloc: loadingFormBloc.indexDateTime,
                                canSelectTime: true,
                                format: DateFormat('dd-mm-yyyy  hh:mm'),
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                                decoration: InputDecoration(
                                  labelText: 'Next index time',
                                  prefixIcon: Icon(Icons.date_range),
                                  helperText: 'Date and Time',
                                ),
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: loadingFormBloc.indexFrequency,
                                decoration: InputDecoration(
                                  labelText: 'Index frequency (hours)',
                                  prefixIcon: Icon(Icons.timer),
                                ),
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: loadingFormBloc.thumbPhotoSize,
                                decoration: InputDecoration(
                                  labelText: 'Photo thumbnail size',
                                  prefixIcon: Icon(Icons.photo),
                                ),
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: loadingFormBloc.smallPhotoSize,
                                decoration: InputDecoration(
                                  labelText: 'Photo small size',
                                  prefixIcon: Icon(Icons.photo),
                                ),
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: loadingFormBloc.largePhotoSize,
                                decoration: InputDecoration(
                                  labelText: 'Photo large size',
                                  prefixIcon: Icon(Icons.photo),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  RaisedButton(
                                    onPressed: loadingFormBloc.submit,
                                    color: Colors.blue,
                                    child: Text(
                                      'Save Settings',
                                      style: TextStyle(
                                          color: Colors.white
                                      )
                                    ),
                                  ),
                                  RaisedButton(
                                    onPressed: () => {
                                      Navigator.of(context).pushNamed("/index-now")
                                    },
                                    child: Text('Index Now...'),
                                  ),
                                  RaisedButton(
                                    onPressed: () => {
                                      Navigator.of(context).pushNamed("/clear-cache")
                                    },
                                    child: Text('Clear Cache...'),
                                  ),
                                ]
                              )
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