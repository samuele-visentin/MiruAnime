import 'package:miru_anime/backend/globals/server_types.dart';

class AnimeWorldServer {
  final ServerName name;
  final bool canDownload;
  final List<AnimeWorldEpisode> listEpisode;

  AnimeWorldServer({
    required this.name,
    required this.canDownload,
    required this.listEpisode
  });
}

class AnimeWorldEpisode {
  final String title;
  final String referer;
  final String dataID;
  final String commentID;
  final bool isFinal;

  AnimeWorldEpisode({
    required this.title,
    required this.commentID,
    required this.dataID,
    required this.isFinal,
    required this.referer
  });
}