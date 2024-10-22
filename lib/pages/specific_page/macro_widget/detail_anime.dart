import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miru_anime/app_theme/app_colors.dart';
import 'package:miru_anime/backend/models/anime_cast.dart';
import 'package:miru_anime/backend/models/specific_page.dart';
import 'package:miru_anime/pages/specific_page/macro_widget/description.dart';
import 'package:miru_anime/pages/specific_page/macro_widget/info_anime.dart';
import 'package:miru_anime/utils/transition.dart';
import 'package:miru_anime/widgets/app_scaffold.dart';
import 'package:miru_anime/widgets/gallery/fullscreen_image.dart';
import 'package:miru_anime/widgets/gallery/thumbnail_anime.dart';
import 'package:miru_anime/widgets/shimmer_box.dart';
import 'package:miru_anime/widgets/underline_title_close_button.dart';
import 'package:resize/resize.dart';


class DetailWidget extends StatelessWidget {
  final DetailAnime detail;
  final String nextEpisode;
  final String description;
  final Future<List<AnimeCast>> cast;

  const DetailWidget({
    super.key,
    required this.description,
    required this.detail,
    required this.nextEpisode,
    required this.cast,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          child: Row(
            children: [
              Text('Sinossi', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        Description(description: description),
        InfoAnime(info: detail, nextEpisode: nextEpisode),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          child: Row(
            children: [
              Text('Cast', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        //const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        SizedBox(
          height: 185,
          child: FutureBuilder<List<AnimeCast>>(
            future: cast,
            builder: (_, asyncsnap) {
              switch (asyncsnap.connectionState) {
                case ConnectionState.done:
                  return asyncsnap.hasError ?
                    Text(asyncsnap.error.toString(),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.functionalred),
                  ) : _Cast(cast: asyncsnap.data!);
                default:
                  return const _ShimmerCast();
              }
            },
          ),
        )
      ],
    );

    return AppScaffold(
      route: '',
      child: SafeArea(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            const UnderlineTitleWithCloseButton(text: 'Informazioni anime'),
            Expanded(
              child: CupertinoScrollbar(
                child: SingleChildScrollView(
                  child: content,
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}

class _ShimmerCast extends StatelessWidget {
  const _ShimmerCast();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: 4,
      itemBuilder: (_, __) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: ShimmerBox(height: 150, width: 110,),
        );
      },
    );
  }
}


class _Cast extends StatelessWidget {
  final List<AnimeCast> cast;
  const _Cast({required this.cast});

  @override
  Widget build(BuildContext context) {
    if(cast.isEmpty) {
      return Center(
        child: Text('Nessun personaggio', style: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Colors.white
        ),),
      );
    }
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      physics: const BouncingScrollPhysics(),
      itemCount: cast.length,
      itemBuilder: (_, index) {
        final character = cast[index];
        return Column(
          children: [
            _CastAvatar(
              url: character.animeCharImg,
              name: character.animeCharName,
              role: character.role,
            ),
          ],
        );
      },
    );
  }
}

class _CastAvatar extends StatelessWidget {
  final String url;
  final String name;
  final String role;
  const _CastAvatar({required this.url, required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_,__,___) => ViewImage(url: url, title: name,),
            transitionsBuilder: transitionBuilder
          )
        ),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Container(
              height: 150.5,
              foregroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                gradient: const LinearGradient(
                  colors: [
                    Colors.transparent,
                    Color.fromRGBO(0, 0, 0, 0.9)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
                )
              ),
              child: ThumbnailAnime(
                image: url,
                width: 110,
                height: 150,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: SizedBox(
                    width: 100,
                    child: Text(name,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.white,
                        fontSize: 10.sp
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  child: Text(role,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 7.sp,
                      color: Colors.white.withAlpha(130)
                    ),
                  ),
                ),
              ],
            )
          ],
        )
      ),
    );
  }
}



