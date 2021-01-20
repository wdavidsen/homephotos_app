import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:homephotos_app/components/error_retry_message.dart';
import 'package:homephotos_app/components/loading_dialog.dart';
import 'package:homephotos_app/components/main_nav_menu.dart';
import 'package:homephotos_app/models/user.dart';
import 'package:homephotos_app/screens/users/users_form_bloc.dart';

class UsersFormScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => UsersFormBloc(),
      child: Builder(
        builder: (context) {
          final usersFormBloc = BlocProvider.of<UsersFormBloc>(context);

          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Scaffold(
              appBar: AppBar(title: Text('Users')),
              drawer: Drawer(
                child: MainNavMenu.build(context),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => Navigator.pushNamed(context, '/user-detail'),
                child: Icon(Icons.add),
              ),
              body: FormBlocListener<UsersFormBloc, String, String>(
                onLoading: (context, state) {
                  LoadingDialog.show(context);
                },
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
                child: BlocBuilder<UsersFormBloc, FormBlocState>(
                  buildWhen: (previous, current) => previous.runtimeType != current.runtimeType || previous is FormBlocLoading && current is FormBlocLoading,
                  builder: (context, state) {

                  if (state is FormBlocLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  else if (state is FormBlocLoadFailed) {
                    return ErrorRetryMessage.build(context, usersFormBloc.reload, state.failureResponse);
                  }
                  else {
                    return SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: StreamBuilder(
                                stream: usersFormBloc.users,
                                builder: (context, AsyncSnapshot<List<User>> snapshot) {
                                  if (snapshot.hasData) {
                                    return buildTable(context, snapshot);
                                  }
                                  else if (snapshot.hasError) {
                                    return Text(snapshot.error.toString());
                                  }
                                  return Text("");
                                },
                              ),
                            ),
                            Divider()
                            // ElevatedButton(
                            //   child: Text("Navigate to user detail"),
                            //   onPressed: () {
                            //     // When the user taps the button, navigate to a named route
                            //     // and provide the arguments as an optional parameter.
                            //     Navigator.pushNamed(
                            //         context,
                            //         '/user-detail',
                            //         arguments: 1
                            //     );
                            //   },
                            //)
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

  Widget buildList(AsyncSnapshot<List<User>> snapshot) {
    return GridView.builder(
        itemCount: snapshot.data.length,
        shrinkWrap: true,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return Text("${snapshot.data[index].username}");
          }
        );
  }

  Widget buildTable(BuildContext context, AsyncSnapshot<List<User>> snapshot) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Text(
            'Name',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Role',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Enabled',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
      rows: _buildTableRows(context, snapshot.data),
    );
  }

  List<DataRow> _buildTableRows(BuildContext context, List<User> users) {
    final dataRows = List<DataRow>();

    users.forEach((user) {
      dataRows.add(DataRow(
        cells: <DataCell>[
          DataCell(
            Text("${user.firstName} ${user.lastName}"),
            onTap: () => { _goToDetail(context, user.userId) }
          ),
          DataCell(
            Text(user.role),
            onTap: () => { _goToDetail(context, user.userId) }
          ),
          DataCell(
            Text(user.enabled ? "Yes" : "No"),
            onTap: () => { _goToDetail(context, user.userId) }
          ),
        ],
      ));
    });
    return dataRows;
  }

  void _goToDetail(BuildContext context, int userId) {
    Navigator.pushNamed(
        context,
        '/user-detail',
        arguments: userId
    );
  }
}