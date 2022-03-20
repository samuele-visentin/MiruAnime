import 'package:dio/dio.dart';

class AwParser {
  final _dio = Dio();

  Future<String> getUrl(final String grabber) async {
    final masterUrl = grabber.split('link=')[1].replaceAll(RegExp(r'//[/]+'), '//');
    if(!masterUrl.contains('playlist.m3u8')) {
      return masterUrl;
    }
    final resolutions = (await _dio.get(masterUrl)).data.toString();
    final listRes = RegExp(r'./[0-9]+p/[\w]+_[0-9]+p.m3u8',caseSensitive: false).allMatches(resolutions).toList();
    return masterUrl.split('playlist.m3u8')[0] + listRes.first[0]!;
  }

}