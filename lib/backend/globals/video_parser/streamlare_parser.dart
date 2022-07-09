import 'package:dio/dio.dart';
import 'package:miru_anime/backend/sites/animeworld/scraper.dart';
import 'package:miru_anime/backend/globals/video_url.dart';

class StreamlareParser {
  final _dio = Dio();

  Future<DirectUrlVideo> getUrlVideo(final String url) async {
    //we get this page for the cookie
    final Response<String> response = await _dio.get(url,
      options: Options(
        headers: {
          'Referer' : 'https://www.animeworld.tv/',
          'User-Agent' : userAgent
        }
      )
    );
    final cookies = response.headers['set-cookie']!;
    final xsrfToken = cookies[0].split(';')[0];
    final regexCsrfToken = RegExp('"csrf-token" content="(.*)">');
    final csrfToken = regexCsrfToken.firstMatch(response.data!)!.group(1);
    final id = Uri.parse(url).pathSegments[1];
    final json = (await _dio.post(
      'https://streamlare.com/api/video/stream/get',
      data: FormData.fromMap({'id' : id}),
      options: Options(
        headers: {
          'User-Agent': userAgent,
          'Referer' : url,
          'X-Requested-With' : 'XMLHttpRequest',
          'X-XSRF-TOKEN' : xsrfToken.replaceAll('%3D', '='),
          'X-CSRF-TOKEN' : csrfToken,
        }
      )
    )).data as Map<String, dynamic>;
    if(json['result']!.containsKey('Original'))
      return DirectUrlVideo(json['result']!['Original']['file'], {});
    else
      return DirectUrlVideo(json['result']!['file'], {});
  }
}