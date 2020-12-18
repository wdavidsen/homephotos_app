import 'package:meta/meta.dart';

class TagState {
  int tagId;
  String tagName;
  bool checked;
  bool indeterminate;
  bool allowIndeterminate;

  TagState({
    @required this.tagName,
    @required this.tagId,
    this.checked = false,
    this.indeterminate = false,
    this.allowIndeterminate = false
  });

  TagState.fromJson(Map<String, dynamic> json)
    : tagId = json['tagId'],
      tagName = json['tagName'],
      checked = json['checked'],
      indeterminate = json['indeterminate'],
      allowIndeterminate = json['allowIndeterminate'];

  Map<String, dynamic> toJson() =>
    {
      'tagId': tagId,
      'tagName': tagName,
      'checked': checked,
      'indeterminate': indeterminate,
      'allowIndeterminate': allowIndeterminate,
    };
}