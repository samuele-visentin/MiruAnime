import 'package:flutter_downloader/flutter_downloader.dart';

class DirectUrlVideo {
  final String urlVideo;
  final Map<String,String> headers;

  DirectUrlVideo(this.urlVideo, this.headers);
}

class AppDownloadTask {
  final String name;
  final String id;
  DownloadTaskStatus status;

  AppDownloadTask(this.name, this.status, this.id);
}