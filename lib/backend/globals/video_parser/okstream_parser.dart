import 'package:dio/dio.dart';

class OkstreamParser {
  final _dio = Dio();

  Future<String> getUrl(final String grabber) async {
    final String page = (await _dio.get(grabber)).data;
    final morocco =
    page.split('<script type="text/javascript">var keys="')[1].split('"')[0];
    final mycountry = page
        .split('<script type="text/javascript">var protection="')[1]
        .split('"')[0];
    final finalUrl = (await _dio.post(
      'https://www.okstream.cc/request/',
      data: FormData.fromMap({
        'morocco': morocco,
        'mycountry': mycountry,
      }),
    )).data.toString();
    return finalUrl.split('.mp4')[0];
  }
}