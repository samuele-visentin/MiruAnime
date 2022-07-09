import 'package:dio/dio.dart';

class BetaserverParser {
  final _dio = Dio();

  Future<String> getUrl(final String grabber) async {
    final List<BetaStreamer> list = [];
    final betaStreamUrl = grabber.split('/')[4].split('#')[0];
    final finalUrl = 'https://animeworld.biz/api/source/$betaStreamUrl';
    final form = FormData.fromMap({'r': '', 'd': 'www.animewolrd.biz'});
    final result = List<Map<String, dynamic>>.from(Map<String, dynamic>.from(
        (await _dio.post(finalUrl,
            options: Options(headers: {'x-requested-with': 'XMLHttpRequest'}),
            data: form))
            .data)['data']);
    for (final res in result) {
      list.add(BetaStreamer(
        url: res['file'],
        quality: int.parse(res['label'].split('p')[0]),
        type: res['type'],
      ));
    }
    list.sort((final a, b) => a.quality.compareTo(b.quality));
    return list.last.url;
  }
}

class BetaStreamer {
  final String url;
  final int quality;
  final String type;

  BetaStreamer(
      {required this.url, required this.quality, required this.type});
}