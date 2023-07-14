import 'package:dio/dio.dart';

class AppUpdater {
  //TODO change for all version
  static const _version = 'v1.6';
  final _dio = Dio();

  Future<bool> checkNewVersions() async {
    final Map<String, dynamic> json = (await _dio.get('')).data;
    return json['tag_name'] != _version;
  }
}