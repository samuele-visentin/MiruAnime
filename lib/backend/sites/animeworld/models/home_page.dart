import 'dart:core';
import 'package:miru_anime/backend/sites/animeworld/models/anime.dart';

class AnimeWorldHomePage {
  final List<List<Anime>> topAnime;
  final List<Anime> sliders;
  final List<Anime> all;
  final List<Anime> subITA;
  final List<Anime> dubbed;
  final List<Anime> trending;
  final List<Anime> ongoing;
  final List<Anime> newAdded;
  final List<Anime> upcoming;
  final String upcomingTitle;

  AnimeWorldHomePage({
    required this.topAnime,
    required this.all,
    required this.sliders,
    required this.subITA,
    required this.dubbed,
    required this.trending,
    required this.ongoing,
    required this.newAdded,
    required this.upcoming,
    required this.upcomingTitle
  });
}
