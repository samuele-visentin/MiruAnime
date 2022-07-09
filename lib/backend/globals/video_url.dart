import 'package:flutter_downloader/flutter_downloader.dart';

class DirectUrlVideo {
  final String urlVideo;
  final Map<String,String> headers;

  DirectUrlVideo(this.urlVideo, this.headers);
}

class AppDownloadTask {
  String id;
  int progress;
  DownloadTaskStatus status;

  AppDownloadTask(this.id, this.status, this.progress);
}