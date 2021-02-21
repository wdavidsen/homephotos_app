import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:homephotos_app/components/error_retry_message.dart';
import 'package:homephotos_app/components/loading_dialog.dart';
import 'package:homephotos_app/components/main_nav_menu.dart';
import 'package:homephotos_app/models/photo.dart';
import 'package:homephotos_app/screens/photos/photos_form_bloc.dart';

class PhotosFormScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final String tagName = ModalRoute.of(context).settings.arguments;

    return BlocProvider(
      create: (context) => PhotosFormBloc(),
      child: Builder(
        builder: (context) {
          final photosFormBloc = BlocProvider.of<PhotosFormBloc>(context);
          photosFormBloc.selectedTagName = tagName;

          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Scaffold(
              appBar: AppBar(title: Text('Photos')),
              drawer: Drawer(
                child: MainNavMenu.build(context),
              ),
              // floatingActionButton: FloatingActionButton(
              //   onPressed: () => Navigator.pushNamed(context, '/user-detail'),
              //   child: Icon(Icons.add),
              // ),
              body: FormBlocListener<PhotosFormBloc, String, String>(
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
                child: BlocBuilder<PhotosFormBloc, FormBlocState>(
                  buildWhen: (previous, current) => previous.runtimeType != current.runtimeType || previous is FormBlocLoading && current is FormBlocLoading,
                  builder: (context, state) {

                    if (state is FormBlocLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    else if (state is FormBlocLoadFailed) {
                      return ErrorRetryMessage.build(context, photosFormBloc.reload, state.failureResponse);
                    }
                    else {
                      return StreamBuilder(
                        stream: photosFormBloc.photos,
                        builder: (context, AsyncSnapshot<List<Photo>> snapshot) {
                          if (snapshot.hasData) {
                            return buildPhotos2(photosFormBloc.baseImageUrl, context, snapshot);
                          }
                          else if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }
                          return Text("");
                        },
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

  Widget buildPhotos2(String baseImageUrl, BuildContext context, AsyncSnapshot<List<Photo>> snapshot) {
    return GridView.builder(
        itemCount: snapshot.data.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2),
        itemBuilder: (context, index) {
          return Padding(
              padding: EdgeInsets.all(5),
              child: Container(
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                          image: new NetworkImage(_buildThumbnailUrl(baseImageUrl, snapshot.data[index])),
                          fit: BoxFit.cover
                    )
                  )
              )
          );
        });
  }

  Widget buildPhotos(String baseImageUrl, BuildContext context, AsyncSnapshot<List<Photo>> snapshot) {
    var thumbs = List<Widget>();
    snapshot.data.forEach((photo) {
      // thumbs.add(_buildThumbnail(baseImageUrl, photo));
    });

    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: thumbs,
    );
  }

  String _buildThumbnailUrl(String baseUrl, Photo photo) {
    return '${baseUrl}/${photo.cacheFolder}/${photo.fileName}';
  }
}