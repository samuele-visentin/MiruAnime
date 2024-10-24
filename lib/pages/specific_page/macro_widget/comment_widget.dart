import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miru_anime/backend/models/comment.dart';
import 'package:miru_anime/utils/transition.dart';
import 'package:miru_anime/widgets/app_scaffold.dart';
import 'package:miru_anime/widgets/default_error_page.dart';
import 'package:miru_anime/widgets/gallery/fullscreen_image.dart';
import 'package:miru_anime/widgets/underline_title_close_button.dart';

class CommentWidget extends StatelessWidget {
  final Future<List<UserComment>> comments;
  final String name;
  const CommentWidget({super.key, required this.comments, required this.name});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      route: '',
      child: SafeArea(
        child: Column(
          children: [
            UnderlineTitleWithCloseButton(text: name),
            Expanded(
              child: FutureBuilder<List<UserComment>>(
                future: comments,
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
                                .bodyMedium
                          ),
                        );
                      }
                      return _buildComment(snap.data!);
                    default:
                      return Center(
                        child: SizedBox(
                          width: 35,
                          height: 35,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComment(final List<UserComment> comments) {
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
              color: Theme.of(context).colorScheme.onSurface,
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
                            right: 0,
                            top: 0,
                            child: Text(
                              comment.time,
                              style: TextStyle(
                                  fontSize: 13.5,
                                  color: Theme.of(context).colorScheme.primary.withAlpha(100),
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (_,__,___) => ViewImage(url: comment.image),
                                    transitionsBuilder: transitionBuilder
                                  )
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image(
                                    width: 55,
                                    height: 55,
                                    image: CachedNetworkImageProvider(comment.image),
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
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                      letterSpacing: -0.25,
                                      fontSize: 18,
                                      color: Theme.of(context).colorScheme.primary,
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
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                    letterSpacing: -0.25,
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500),
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