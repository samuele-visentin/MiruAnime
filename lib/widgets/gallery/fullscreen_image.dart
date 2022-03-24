import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:miru_anime/constants/app_colors.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewImage extends StatelessWidget {
  final String url;
  final bool useCache;
  const ViewImage({Key? key, required this.url, this.useCache = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Image View',
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.center,
        ),
      ),
      body: GestureDetector(
        onLongPress: () async {
          await launch(url);
        },
        child: PhotoView(
          filterQuality: FilterQuality.medium,
          backgroundDecoration: const BoxDecoration(
            color: AppColors.background
          ),
          imageProvider: (useCache ? CachedNetworkImageProvider(url) : NetworkImage(url)) as ImageProvider<Object>,
          maxScale: PhotoViewComputedScale.covered * 2,
          minScale: PhotoViewComputedScale.contained * 0.5,
        ),
      ),
    );
  }
}


