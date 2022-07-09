import 'package:objectbox/objectbox.dart';

@Entity()
class AnimeDatabase {
  int id;
  @Index() final String animeID;
  final String title;
  final String imgUrl;
  final String animeUrl;
  final String currentEpisode;
  final String time;
  final bool userFinishedToWatch;
  final bool animeIsFinished;

  AnimeDatabase({
    this.id = 0,
    required this.animeID,
    required this.title,
    required this.imgUrl,
    required this.animeUrl,
    required this.currentEpisode,
    required this.time,
    required this.animeIsFinished,
    required this.userFinishedToWatch
  });
}