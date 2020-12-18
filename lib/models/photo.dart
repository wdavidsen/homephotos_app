import 'package:meta/meta.dart';

class Photo {
  int photoId;
  DateTime dateTaken;
  String cacheFolder;
  String fileName;
  int imageWidth;
  int imageHeight;

  Photo({this.cacheFolder,
    this.fileName,
    this.dateTaken,
    this.photoId,
    this.imageWidth,
    this.imageHeight
  });

  Photo.fromJson(Map<String, dynamic> json)
    : photoId = json['photoId'],
      dateTaken = json['dateTaken'],
      cacheFolder = json['cacheFolder'],
      fileName = json['fileName'],
      imageWidth = json['imageWidth'],
      imageHeight = json['imageHeight'];

  Map<String, dynamic> toJson() =>
    {
      'photoId': photoId,
      'dateTaken': dateTaken,
      'cacheFolder': cacheFolder,
      'fileName': fileName,
      'imageWidth': imageWidth,
      'imageHeight': imageHeight,
    };
}