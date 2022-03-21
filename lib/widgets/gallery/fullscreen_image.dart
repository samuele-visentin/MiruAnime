import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewImage extends StatelessWidget {
  final String url;
  final bool useCache;
  const ViewImage({Key? key, required this.url, this.useCache = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        await launch(url);
      },
      child: PhotoView(
        imageProvider: (useCache ? CachedNetworkImageProvider(url) : NetworkImage(url)) as ImageProvider<Object>,
        maxScale: PhotoViewComputedScale.covered * 2,
        minScale: PhotoViewComputedScale.contained * 0.5,
      ),
    );
  }
}


