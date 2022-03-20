import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:miru_anime/constants/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';

class ViewImage extends StatelessWidget {
  final String url;
  final bool useCache;
  const ViewImage({Key? key, required this.url, this.useCache = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        if(await Permission.storage.request() == PermissionStatus.denied){
          Fluttertoast.showToast(
            msg: 'Permessi negati, download cancellato',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: AppColors.grey,
            textColor: Colors.black
          );
          return;
        }
        //TODO: download image
      },
      child: PhotoView(
        imageProvider: (useCache ? CachedNetworkImageProvider(url) : NetworkImage(url)) as ImageProvider<Object>,
        maxScale: PhotoViewComputedScale.covered * 2,
        minScale: PhotoViewComputedScale.contained * 0.5,
      ),
    );
  }
}


