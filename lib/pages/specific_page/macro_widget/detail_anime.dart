import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:miru_anime/widgets/shimmer_box.dart';
import 'package:miru_anime/widgets/underline_title_close_button.dart';
import 'package:resize/resize.dart';


class DetailWidget extends StatelessWidget {
  final DetailAnime detail;
  final String nextEpisode;
  final String description;
  final Future<List<AnimeCast>>? cast;

  const DetailWidget({
    Key? key,
    required this.description,
    required this.detail,
    required this.nextEpisode,
    required this.cast,
  }) : super(key: key);

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
        Visibility(
          visible: cast != null,
          child: SizedBox(
            height: 300,
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
  const _ShimmerCast({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: 4,
      itemBuilder: (_, __) {
        return Column(
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ShimmerBox(height: 80, width: 80, radius: 40,),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 15)),
            ShimmerBox(height: 80, width: 80, radius: 40,),
          ],
        );
      },
    );
  }
}


class _Cast extends StatelessWidget {
  final List<AnimeCast> cast;
  const _Cast({Key? key, required this.cast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(cast.isEmpty) {
      return Center(
        child: Text('Nessun personaggio', style: Theme.of(context).textTheme.bodySmall,),
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
            _CircleAvatar(url: character.animeCharImg, name: character.animeCharName),
            const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: SizedBox(
                width: 100,
                height: 32,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Center(
                    child: Text(
                      character.animeCharName,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 11.sp),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                )
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
            Text(character.role, style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 10.sp),),
            const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
            _CircleAvatar(url: character.realCharImg, name: character.realCharName,),
            const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
            SizedBox(
                width: 100,
                height: 32,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Center(
                    child: Text(
                      character.realCharName,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 11.sp),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                )
            ),
          ],
        );
      },
    );
  }
}

class _CircleAvatar extends StatelessWidget {
  final String url;
  final String name;
  const _CircleAvatar({Key? key, required this.url, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (_,__,___) => ViewImage(url: url, title: name,),
          transitionsBuilder: transitionBuilder
        )
      ),
      child: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        radius: 41.5,
        child: CircleAvatar(
          radius: 40,
          backgroundImage: CachedNetworkImageProvider(url),
          backgroundColor: const Color(0xff212121),
        ),
      ),
    );
  }
}



