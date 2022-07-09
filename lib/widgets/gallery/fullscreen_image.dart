import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:miru_anime/widgets/title_close_button.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewImage extends StatelessWidget {
  final String url;
  final bool useCache;
  final String title;
  const ViewImage({Key? key, required this.url, this.useCache = true, this.title = 'Fullscreen Image'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TitleWithCloseButton(text: title),
            Expanded(
              child: GestureDetector(
                onLongPress: () async {
                  await launchUrl(Uri.parse(url));
                },
                child: PhotoView(
                  filterQuality: FilterQuality.high,
                  backgroundDecoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor
                  ),
                  imageProvider: (useCache ? CachedNetworkImageProvider(url) : NetworkImage(url)) as ImageProvider<Object>,
                  maxScale: PhotoViewComputedScale.covered * 2,
                  minScale: PhotoViewComputedScale.contained * 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


