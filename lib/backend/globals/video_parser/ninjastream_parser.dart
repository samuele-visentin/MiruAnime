import 'package:dio/dio.dart';

class NinjastreamParser {
  final _dio = Dio();

  Future<String> getUrl(final String grabber, final String referer) async {
    final document = (await _dio.get(
        grabber,
        options: Options(headers: {'Referer' : referer})
    ));
    final session = document.headers['set-cookie']![2].split(';')[0];
    final xsrf = document.headers['set-cookie']![1].split(';')[0];
    final ddg = document.headers['set-cookie']![0].split(';')[0];
    final csrf = document.data.toString().split('csrf-token')[1].split('content="')[1].split('"')[0];
    final id = document.data.toString().split('hashid&quot;:&quot;')[1].split('&quot;')[0];
    final Map<String, dynamic> ninjaResult = (await _dio.post(
        'https://ninjastream.to/api/video/get',
        options: Options(headers: {
          'Referer' : grabber,
          'X-Requested-With' : 'XMLHttpRequest',
          'Cookie' : '$ddg; $xsrf; $session; ',
          'User-Agent' : 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0',
          'X-CRSF-TOKEN' : csrf,
          'Origin' : 'https://ninjastream.to',
          'X-XSRF-TOKEN' : '${xsrf.split('=')[1].split('%')[0]}=',
        }),
        data: FormData.fromMap({'id' : id})
    )).data['result'];
    if(ninjaResult.containsKey('mp4')){
      final mapMp4 = ninjaResult['mp4'] as List;
      int resolution = 0;
      String link = 'null';
      for (final element in mapMp4) {
        final temp = int.tryParse(element['label'].toString().replaceAll('p', ''));
        if((temp ?? 0) > resolution){
          resolution = temp!;
          link = element['url'];
        }
      }
      return link;
    }
    if(ninjaResult['playlist'].toString().contains('index.m3u8')) {
      final rawResolutions = (await _dio.get(ninjaResult['playlist'].toString())).data.toString();
      final resolutions = RegExp(r'[0-9]+_[0-9]+p.m3u8').allMatches(rawResolutions).toList();
      return ninjaResult['playlist'].toString().split('index.m3u8')[0] + resolutions.last[0]!;
    }
    return ninjaResult['playlist'].toString();
  }
}