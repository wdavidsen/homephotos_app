import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:homephotos_app/screens/services/service_field_bloc.dart';

class ServiceFormCard extends StatelessWidget {
  final int serviceIndex;
  final ServiceFieldBloc serviceField;
  final VoidCallback onRemoveService;

  const ServiceFormCard({
    Key key,
    @required this.serviceIndex,
    @required this.serviceField,
    @required this.onRemoveService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Service ${serviceIndex + 1}',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: onRemoveService,
                ),
              ],
            ),
            TextFieldBlocBuilder(
              textFieldBloc: serviceField.serviceName,
              decoration: InputDecoration(
                labelText: 'Service name',
              ),
            ),
            TextFieldBlocBuilder(
              textFieldBloc: serviceField.serviceUrl,
              decoration: InputDecoration(
                labelText: 'Service address',
              ),
            ),
          ],
        ),
      ),
    );
  }
}