import 'dart:math';

import 'package:dio/dio.dart';
import 'package:miru_anime/backend/sites/video_url.dart';

class DoodstreamParser {
  final _dio = Dio();

  Future<DirectUrlVideo> getUrl(final String grabber) async {
    final Response<String> page = await _dio.get(grabber);
    final regex = RegExp(r"\$\.get\('(\/pass_md5[^']+)");
    final md5UrlString = regex.firstMatch(page.data!)!;
    final md5Url = 'https://dood.so' + md5UrlString.group(1)!;
    final md5Token = Uri.parse(md5Url).pathSegments.last;
    final String partialLink = (await _dio.get(
        md5Url,
        options: Options(
            headers: {
              'Referer' : grabber,
              'X-Requested-With': 'XMLHttpRequest'
            }
        )
    )).data;
    // Add 10 random letters to the url base
    // the token extracted from before
    // and an expiry date containing the current date
    const letters = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final _rnd = Random();
    final String randomLetters = String.fromCharCodes(
        Iterable.generate(10, (_) => letters.codeUnitAt(_rnd.nextInt(letters.length))
        ));
    final date = DateTime.now().millisecondsSinceEpoch.toString();
    return DirectUrlVideo('$partialLink$randomLetters?token$md5Token&expiry=$date', {
      'Referer' : 'https://dood.so/',
    });
  }
}