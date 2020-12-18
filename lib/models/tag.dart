import 'package:meta/meta.dart';

class Tag {
  int tagId;
  String tagName;
  int photoCount;

  Tag({
    @required this.tagName,
    this.tagId,
    this.photoCount
  });

  Tag.fromJson(Map<String, dynamic> json)
    : tagId = json['tagId'],
      tagName = json['tagName'],
      photoCount = json['photoCount'];

  Map<String, dynamic> toJson() =>
    {
      'tagId': tagId,
      'tagName': tagName,
      'photoCount': photoCount,
    };
}