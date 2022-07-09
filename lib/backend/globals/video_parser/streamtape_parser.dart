import 'package:dio/dio.dart';
import 'package:miru_anime/backend/globals/video_url.dart';

class StreamtapeParser {
  final _dio = Dio();

  Future<DirectUrlVideo> getUrl(final String grabber, final String referer) async {
    final Response<String> page = await _dio.get(
        grabber,
        options: Options(
            headers: {
              'Referer': referer,
            }
        )
    );
    final regex = RegExp(r"\('robotlink'\)\.innerHTML = '(.*)'\+ \((.*)'");
    final matches = regex.firstMatch(page.data!);
    final finalUrl = matches!.group(2)!.substring(4);
    return DirectUrlVideo('https:${matches.group(1)!}$finalUrl', {});
  }
}