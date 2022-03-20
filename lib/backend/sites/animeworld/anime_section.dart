
import 'package:miru_anime/backend/sites/animeworld/endpoints.dart';
import 'package:miru_anime/backend/sites/animeworld/models/anime.dart';

class AnimeSection {
  final String _route;
  final String _url;
  final String _name;
  const AnimeSection._(this._route, this._url, this._name);

  String get route => _route;
  String get url => _url;
  String get name => _name;

  static const ongoing = AnimeSection._('/ongoing', AnimeWorldEndPoints.ongoing, 'In corso');
  static const newAdded = AnimeSection._('/newadded', AnimeWorldEndPoints.newest, 'Nuove aggiunte');
  static const last = AnimeSection._('/lastepisode', AnimeWorldEndPoints.last, 'Ultimi episodi');
  static const anime = AnimeSection._('/anime', AnimeWorldEndPoints.anime, 'Anime');
  static const movie = AnimeSection._('/movie', AnimeWorldEndPoints.movies, 'Movies');
  static const ova = AnimeSection._('/ova', AnimeWorldEndPoints.ova, 'OVA');
  static const ona = AnimeSection._('/ona', AnimeWorldEndPoints.ona, 'ONA');
  static const music = AnimeSection._('/music', AnimeWorldEndPoints.movies, 'Music');
  static const special = AnimeSection._('/special', AnimeWorldEndPoints.special, 'Special');
}

class AnimeGenericData {
  final List<Anime> list;
  final int maxPage;

  const AnimeGenericData(this.list, this.maxPage);
}