
class AnimeWorldComment{
  final String referer; // link per referer per i commenti
  final String token; // token per chiedere i commenti
  final String commentId;  // token per i commenti

  AnimeWorldComment({
    required this.referer,
    required this.token,
    required this.commentId
  });
}

class UserComment {
  final String image;
  final String text;
  final String name;
  final String time;

  UserComment({
    required this.name,
    required this.text,
    required this.image,
    required this.time
  });
}