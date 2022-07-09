class News {
  final String time;
  final String body;
  final String url;
  final String views;
  final String img;
  final String title;
  final String type;


  News({required this.time, required this.body, required this.url, required this.views, required this.img, required this.title, required this.type});
}

class NewsData {
  final List<News> news;
  final int maxPage;

  NewsData(this.news, this.maxPage);
}

