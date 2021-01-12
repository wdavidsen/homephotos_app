import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:homephotos_app/components/loading_dialog.dart';
import 'package:homephotos_app/screens/services/service_form_card.dart';
import 'package:homephotos_app/screens/services/service_field_bloc.dart';
import 'package:homephotos_app/screens/services/service_form_bloc.dart';

class ServicesFormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServicesFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = context.bloc<ServicesFormBloc>();

          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(title: Text('Photo Services')),
              floatingActionButton: FloatingActionButton(
                onPressed: formBloc.submit,
                child: Icon(Icons.check),
              ),
              body: FormBlocListener<ServicesFormBloc, String, String>(
                onSubmitting: (context, state) {
                  LoadingDialog.show(context);
                },
                onSuccess: (context, state) {
                  LoadingDialog.hide(context);

                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: SingleChildScrollView(
                        child: Text(state.successResponse)),
                    duration: Duration(milliseconds: 1500),
                  ));

                  Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => false);
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
                      BlocBuilder<ListFieldBloc<ServiceFieldBloc>,
                          ListFieldBlocState<ServiceFieldBloc>>(
                        cubit: formBloc.services,
                        builder: (context, state) {
                          if (state.fieldBlocs.isNotEmpty) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.fieldBlocs.length,
                              itemBuilder: (context, i) {
                                return ServiceFormCard(
                                  serviceIndex: i,
                                  serviceField: state.fieldBlocs[i],
                                  onRemoveService: () =>
                                      formBloc.removeService(i),
                                );
                              },
                            );
                          }
                          return Container();
                        },
                      ),
                      RaisedButton(
                        onPressed: () => {
                          formBloc.addService("", "")
                        },
                        child: Text(
                          'Add Service',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}