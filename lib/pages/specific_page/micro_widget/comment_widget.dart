import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miru_anime/backend/sites/animeworld/models/comment.dart';
import 'package:miru_anime/backend/sites/animeworld/scraper.dart';
import 'package:miru_anime/constants/app_colors.dart';
import 'package:miru_anime/utils/transition.dart';
import 'package:miru_anime/widgets/default_error_page.dart';
import 'package:miru_anime/widgets/gallery/fullscreen_image.dart';

class CommentWidget extends StatefulWidget {
  final AnimeWorldComment commentInfo;
  final String? episodeID;
  final String? referer;
  final bool save;
  const CommentWidget({Key? key, required this.commentInfo, this.episodeID, this.referer, this.save = false})
      : super(key: key);

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  late final Future<List<UserComment>> _future;

  @override
  void initState() {
    super.initState();
    if(widget.save == true) {
      final List<UserComment>? storage = PageStorage.of(context)?.readState(context, identifier: List<UserComment>);
      if(storage == null){
        _future = AnimeWorldScraper().getComment(widget.commentInfo, widget.episodeID, widget.referer).then((value){
          PageStorage.of(context)?.writeState(context, value, identifier: List<UserComment>);
          return value;
        });
      } else {
        _future = Future.value(storage);
      }
    } else {
      _future = AnimeWorldScraper().getComment(widget.commentInfo, widget.episodeID, widget.referer);
    }

  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.80),
      child: FutureBuilder<List<UserComment>>(
        future: _future,
        builder: (context, snap){
          switch (snap.connectionState) {
            case ConnectionState.done:
              if (snap.hasError) {
                return DefaultErrorPage(error: snap.error.toString());
              }
              if (snap.data!.isEmpty) {
                return Center(
                  child: Text(
                    'Non ci sono commenti',
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyText1
                  ),
                );
              }
              return buildComment(snap.data!);
            default:
              return const Center(
                child: SizedBox(
                  width: 35,
                  height: 35,
                  child: CircularProgressIndicator(
                    color: AppColors.purple,
                  ),
                ),
              );
          }
        },
      ),
    );
  }

  Widget buildComment(final List<UserComment> comments) {
    return CupertinoScrollbar(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemBuilder: (final context, final index) {
          final comment = comments[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              color: AppColors.white,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 45),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 0.0),
                  child: Column(
                    children: [
                      const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4.0)),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            child: Text(
                              comment.time,
                              style: TextStyle(
                                  fontSize: 13.5,
                                  color: Colors.grey[900],
                                  fontWeight: FontWeight.w300),
                            ),
                            right: 0,
                            top: 0,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (_,__,___) => ViewImage(url: comment.image, useCache: false,),
                                    transitionsBuilder: transitionBuilder
                                  )
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image(
                                    width: 55,
                                    height: 55,
                                    image: NetworkImage(comment.image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding:
                                EdgeInsets.symmetric(horizontal: 8.0),
                              ),
                              Expanded(
                                child: Text(
                                  comment.name,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                      letterSpacing: -0.25,
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0)),
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                                comment.text,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                    letterSpacing: -0.25,
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              )),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: comments.length,
      ),
    );
  }
}