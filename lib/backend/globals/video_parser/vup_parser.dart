import 'package:dio/dio.dart';
import 'package:miru_anime/backend/sites/animeworld/scraper.dart';
import 'package:miru_anime/backend/globals/video_url.dart';

class VupParser {
  final _dio = Dio();

  Future<DirectUrlVideo> getUrlVideo(final String grabber) async {
    final page = (await _dio.get(grabber,
      options: Options(
        headers: {
          'Referer' : 'https://www.animeworld.tv/',
          'User-Agent' : userAgent
        }
      )
    )).data as String;
    final regex = RegExp(r'\[{src: "(.*)",');
    final vupUrl = regex.firstMatch(page)!.group(1);
    return DirectUrlVideo(vupUrl!, {});
  }
}