import 'package:miru_anime/backend/database/anime_saved.dart';

class Anime {
  final String thumbnail;
  final String title;
  final String link;
  final String? rank;
  final String? info;

  Anime({
    required this.thumbnail,
    required this.title,
    required this.link,
    this.rank,
    this.info,
  });

  factory Anime.fromDatabase(final AnimeDatabase db) {
    return Anime(
      thumbnail: db.imgUrl,
      title: db.title,
      link: db.animeUrl,
      info: db.currentEpisode
    );
  }
}