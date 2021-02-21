import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:homephotos_app/components/error_retry_message.dart';
import 'package:homephotos_app/components/loading_dialog.dart';
import 'package:homephotos_app/components/main_nav_menu.dart';
import 'package:homephotos_app/models/tag.dart';
import 'package:homephotos_app/screens/tags/tags_form_bloc.dart';

class TagsFormScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => TagsFormBloc(),
      child: Builder(
        builder: (context) {
          final tagsFormBloc = BlocProvider.of<TagsFormBloc>(context);

          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Scaffold(
              appBar: AppBar(title: Text('Tags')),
              drawer: Drawer(
                child: MainNavMenu.build(context),
              ),
              // floatingActionButton: FloatingActionButton(
              //   onPressed: () => Navigator.pushNamed(context, '/user-detail'),
              //   child: Icon(Icons.add),
              // ),
              body: FormBlocListener<TagsFormBloc, String, String>(
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
                child: BlocBuilder<TagsFormBloc, FormBlocState>(
                  buildWhen: (previous, current) => previous.runtimeType != current.runtimeType || previous is FormBlocLoading && current is FormBlocLoading,
                  builder: (context, state) {

                    if (state is FormBlocLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    else if (state is FormBlocLoadFailed) {
                      return ErrorRetryMessage.build(context, tagsFormBloc.reload, state.failureResponse);
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
                                  stream: tagsFormBloc.tags,
                                  builder: (context, AsyncSnapshot<List<Tag>> snapshot) {
                                    if (snapshot.hasData) {
                                      return buildTags(context, snapshot);
                                    }
                                    else if (snapshot.hasError) {
                                      return Text(snapshot.error.toString());
                                    }
                                    return Text("");
                                  },
                                ),
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

  Widget buildTags(BuildContext context, AsyncSnapshot<List<Tag>> snapshot) {
    var chips = List<Widget>();
    snapshot.data.forEach((tag) {
      chips.add(_buildChip(context, tag.tagName, tag.photoCount));
    });

    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: chips,
    );
  }

  Widget _buildChip(BuildContext context, String tagName, int photoCount) {
    return ActionChip(
      labelPadding: EdgeInsets.all(2.0),
      // avatar: CircleAvatar(
      //   backgroundColor: Colors.white70,
      //   child: Text(
      //       photoCount.toString(),
      //       overflow: TextOverflow.visible,
      //   ),
      // ),
      label: Text(
        tagName,
        style: TextStyle(
          color: Colors.black54,
        ),
      ),
      backgroundColor: Colors.yellow,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(8.0),
      onPressed: () { _goToPhotos(context, tagName);  },
    );
  }

  void _goToPhotos(BuildContext context, String tagName) {
    Navigator.pushNamed(
        context,
        '/photos',
        arguments: tagName
    );
  }
}