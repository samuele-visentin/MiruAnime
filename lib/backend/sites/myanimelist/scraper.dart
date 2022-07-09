import 'dart:io';

import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:miru_anime/backend/models/anime_cast.dart';
import 'package:miru_anime/backend/sites/animeworld/scraper.dart';

class MyAnimeListScraper {
  final _dio = Dio();

  Future<List<AnimeCast>> getAnimeCast(final String url) async {
    final page = await _dio.get(url, options:
        Options(headers: {
          HttpHeaders.userAgentHeader : userAgent
        })
    );
    final document = parse(page.data);
    final regex = RegExp(r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)');
    final list = <AnimeCast>[];
    for (final e in document.querySelectorAll('#content > table > tbody > tr > td > div > table > tbody > tr > td > div.detail-characters-list.clearfix > div > table')){
      try {
        list.add(
            AnimeCast(
                animeCharImg: regex.allMatches(e.querySelector('a.fw-n > img')!.attributes['data-srcset']!).last.group(0)!,
                realCharImg: regex.allMatches(e.querySelector('tbody > tr > td > table > tbody > tr > td > div > a > img')!.attributes['data-srcset']!).last.group(0)!,
                animeCharName: e.querySelector('tbody > tr > td> h3 > a')?.text.trim() ?? '',
                realCharName: e.querySelector('tbody > tr > td > table > tbody > tr > td.va-t.ar.pl4.pr4 > a')?.text.trim() ?? '',
                role: e.querySelector('div > small')?.text.trim() ?? ''
            )
        );
      } catch (_){}
    }
    return list;
  }
}