class Settings {
  String cacheFolder;
  String mobileUploadsFolder;
  String indexPath;
  DateTime nextIndexTime;
  int indexFrequencyHours;
  int smallImageSize;
  int largeImageSize;
  int thumbnailSize;

  Settings({this.cacheFolder,
    this.mobileUploadsFolder,
    this.indexPath,
    this.nextIndexTime,
    this.indexFrequencyHours,
    this.smallImageSize,
    this.largeImageSize,
    this.thumbnailSize
  });

  Settings.fromJson(Map<String, dynamic> json)
    : cacheFolder = json['cacheFolder'],
      mobileUploadsFolder = json['mobileUploadsFolder'],
      indexPath = json['indexPath'],
      nextIndexTime = DateTime.parse(json['nextIndexTime']),
      indexFrequencyHours = json['indexFrequencyHours'],
      smallImageSize = json['smallImageSize'],
      largeImageSize = json['largeImageSize'],
      thumbnailSize = json['thumbnailSize'];

  Map<String, dynamic> toJson() =>
    {
      'cacheFolder': cacheFolder,
      'mobileUploadsFolder': mobileUploadsFolder,
      'indexPath': indexPath,
      'nextIndexTime': nextIndexTime,
      'indexFrequencyHours': indexFrequencyHours,
      'smallImageSize': smallImageSize,
      'largeImageSize': largeImageSize,
      'thumbnailSize': thumbnailSize,
    };
}