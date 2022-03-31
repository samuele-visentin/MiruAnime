import 'dart:math';

import 'package:dio/dio.dart';
import 'package:miru_anime/backend/sites/animeworld/scraper.dart';
import 'package:miru_anime/backend/sites/video_url.dart';

class UserloadParser {
  final _dio = Dio();

  String _decrypt(String p, int a, int c, List<String> k, int e, Map d) {
    while (c-- > 0) {
      if (c.toRadixString(a).isNotEmpty) d[c.toRadixString(a)] = k[c];
    }
    c = 1;
    while(c-- > 0) {
      if (k[c] != '') {
        p = p.replaceAllMapped(RegExp('\\b\\w+\\b'), (match) => d[match.group(0)]);
      }
    }
    return p;
  }

  Future<DirectUrlVideo> getUrl(final String grabber) async {
    final Response<String> page = await _dio.get(grabber);
    final regex = RegExp('}}return p}\\(\'(.*\\,[0-9]+,[0-9]+\\,.*)\'\\.');
    final encodeUrl =
        regex.firstMatch(page.data!)!.group(1)!.replaceAll('\'', '').split(',');
    final infoUrl = _decrypt(encodeUrl[0], int.parse(encodeUrl[1]), int.parse(encodeUrl[2]), encodeUrl[3].split('|'), 0, {}).replaceAll('"','');
    final regexParam = RegExp('=([^;]*)');
    //we generate 32 random letters and numbers for mycountry value
    const letters = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final _rnd = Random();
    final String randomLetters = String.fromCharCodes(
        Iterable.generate(32, (_) => letters.codeUnitAt(_rnd.nextInt(letters.length))
        ));

    //we brute force the real url by test all the cases (couse the name and the position of morocco's value can change)
    for (final url in regexParam.allMatches(infoUrl)) {
      if(url.group(1)!.isEmpty || url.group(1)!.contains('.mp4'))
        continue;
      final response = (await _dio.post('https://userload.co/api/request/',
          data: FormData.fromMap({
            'morocco' : url.group(1),
            'mycountry' : randomLetters, //random number
          }),
          options: Options(
              headers: {
                'user-agent' : userAgent,
                'referer' : grabber,
                'Content-Type' : 'application/x-www-form-urlencoded',
                'Origin' : 'https://userload.co',
                'Connection' : 'keep-alive'
              }
          )
      )).data as String;
      if(response.contains('<title>') || Uri.tryParse(response) == null) continue; //the page return status OK but the page is 404 error
      return DirectUrlVideo(response, {});
    }
    throw ArgumentError('Uri parser fail');
  }
}
