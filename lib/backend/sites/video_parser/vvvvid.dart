import 'dart:io';

import 'package:dio/dio.dart';
import 'package:miru_anime/backend/sites/video_url.dart';

class VvvvidServer {
  static Map<String, String>? _headers;
  static String? _connId;
  final _dio = Dio();

  Future<void> _init() async {
    _headers = {
      'cookie': (await _dio.get('https://www.vvvvid.it/user/login',
              options: Options(headers: {
                HttpHeaders.userAgentHeader:
                    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36'
              })))
          .headers[HttpHeaders.setCookieHeader]![0]
          .split(';')[0],
      HttpHeaders.userAgentHeader:
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36',
    };
    _connId = (await _dio.get('https://www.vvvvid.it/user/login',
            options: Options(headers: _headers)))
        .data['data']['conn_id'];
  }

  Future<DirectUrlVideo> urlVideo(final String url) async {
    if (_headers == null) {
      await _init();
    }
    return DirectUrlVideo(await _scrape(url), {});
  }

  Future<Response> _dioGet(final String url) =>
      _dio.get(url, options: Options(headers: _headers));

  String _decrypt(final String h) {
    const g =
        'MNOPIJKL89+/4567UVWXQRSTEFGHABCDcdefYZabstuvopqr0123wxyzklmnghij';

    List<int> f(final List<int> m) {
      final List<int> l = [];
      var o = 0;
      var b = false;
      final mLen = m.length;
      while ((!b) && o < mLen) {
        var n = m[o] << 2;
        o += 1;
        var k = -1;
        var j = -1;
        if (o < mLen) {
          n += m[o] >> 4;
          o += 1;
          if (o < mLen) {
            k = (m[o - 1] << 4) & 255;
            k += m[o] >> 2;
            o += 1;
            if (o < mLen) {
              j = (m[o - 1] << 6) & 255;
              j += m[o];
              o += 1;
            } else {
              b = true;
            }
          } else {
            b = true;
          }
        } else {
          b = true;
        }
        l.add(n);
        if (k != -1) {
          l.add(k);
        }
        if (j != -1) {
          l.add(j);
        }
      }
      return l;
    }

    List<int> c = [];
    for (final e in h.split('')) {
      c.add(g.indexOf(e));
    }

    final cLen = c.length;
    for (var e = cLen * 2 - 1; e >= 0; e--) {
      final a = c[e % cLen] ^ c[(e + 1) % cLen];
      c[e % cLen] = a;
    }

    c = f(c);
    var d = '';
    for (final e in c) {
      d += String.fromCharCode(e);
    }

    return d;
  }

  Future<String> _scrape(final String url) async {
    final validUrl = RegExp(
        r'https?://(?:www\.)?vvvvid.it/(?:#)?(?:!)?(?:show|anime|film|series)/(\d+)/[^/]+/(\d+)/([0-9]+)');
    final match = validUrl.firstMatch(url);
    if (match == null) throw ArgumentError('Invalid Url');

    final showId = match.group(1);
    final seasonId = match.group(2);
    final videoId = int.parse(match.group(3)!);

    final endpoint =
        'https://www.vvvvid.it/vvvvid/ondemand/$showId/season/$seasonId?conn_id=$_connId';
    final res = List<Map<String, dynamic>>.from(
      Map<String, dynamic>.from((await _dioGet(endpoint)).data)['data'],
    );
    final videoData =
        res.firstWhere((final episode) => episode['video_id'] == videoId);
    for (final quality in ['', '_sd']) {
      final embedCode = videoData['embed_info$quality'];
      if (embedCode == null) continue;
      var embedCodeDecrypted = _decrypt(embedCode)
          .replaceAllMapped(
              RegExp(r'https?://([^/]+)/z/'), (final m) => 'https://${m[1]}/i/')
          .replaceAll('/manifest.f4m', '/master.m3u8');

      if (videoData['video_type'] == 'video/kenc') {
        final kencUrl =
            'https://www.vvvvid.it/kenc?conn_id=$_connId&action=kt&url=$embedCodeDecrypted';
        final kenc =
            Map<String, String>.from((await _dioGet(kencUrl)).data)['message'];

        if (kenc!.isNotEmpty) {
          final masterM3u =
              (await _dioGet('$embedCodeDecrypted?${_decrypt(kenc)}')).data;
          // NOTE: Some video players don't work with master.m3u8 but work with
          // the url it contains (index_0_av.m3u8)
          embedCodeDecrypted = 'http${masterM3u.split('http')[1]}'.trim();
        }
      }
      return embedCodeDecrypted;
    }
    throw ArgumentError('Invalid quality url');
  }
}
