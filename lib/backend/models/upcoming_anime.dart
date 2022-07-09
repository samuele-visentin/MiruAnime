import 'package:miru_anime/backend/models/anime.dart';

class UpComingAnime {
  final List<Anime> tv;
  final List<Anime> ova;
  final List<Anime> ona;
  final List<Anime> special;
  final List<Anime> movie;

  UpComingAnime({required this.tv, required this.ova, required this.ona, required this.special, required this.movie});
}
