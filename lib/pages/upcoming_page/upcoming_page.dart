import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miru_anime/backend/models/specific_page.dart';
import 'package:miru_anime/backend/sites/animeworld/scraper.dart';
import 'package:miru_anime/pages/upcoming_page/specific_upcoming_page.dart';
import 'package:miru_anime/widgets/app_scaffold.dart';
import 'package:miru_anime/widgets/default_error_page.dart';
import 'package:miru_anime/widgets/rounded_label.dart';
import 'package:miru_anime/widgets/shimmer_box.dart';
import 'package:miru_anime/widgets/underline_title_close_button.dart';

import '../../utils/transition.dart';

class UpcomingPage extends StatefulWidget {
  static const route = '/upcoming';

  const UpcomingPage({Key? key}) : super(key: key);

  @override
  State<UpcomingPage> createState() => _UpcomingPageState();
}

class _UpcomingPageState extends State<UpcomingPage> {
  late final Future<List<Href>> future;

  @override
  void initState() {
    super.initState();
    future = AnimeWorldScraper().getUpcomingSections();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      route: UpcomingPage.route,
      child: SafeArea(
        child: Column(
          children: [
            const UnderlineTitleWithCloseButton(text: 'Prossime uscite'),
            Expanded(
              child: FutureBuilder<List<Href>>(
                future: future,
                builder: (_, snap) {
                  switch(snap.connectionState) {
                    case ConnectionState.done:
                      return snap.hasError ? DefaultErrorPage(error: snap.error.toString()) : _successfulPage(snap.data!);
                    default:
                      return const _ShimmerPage();
                  }
                },
              ),
            )
          ],
        ),
      )
    );
  }

  Widget _successfulPage(final List<Href> sections) {
    return Center(
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        itemCount: sections.length,
        itemBuilder: (_, final index) {
          final item = sections[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (_,__,___) => SpecificUpcomingPage(
                    name: item.name,
                    url: item.url,
                  ),
                  transitionsBuilder: transitionBuilder
                )
              ),
              child: RoundedLabel(
                name: item.name
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ShimmerPage extends StatelessWidget {
  const _ShimmerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        children: const [
          Padding(
            padding: EdgeInsets.all(8),
            child: ShimmerBox(height: 45, width: 300, radius: 20,),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: ShimmerBox(height: 45, width: 300, radius: 20,),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: ShimmerBox(height: 45, width: 300, radius: 20,),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: ShimmerBox(height: 45, width: 300, radius: 20,),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: ShimmerBox(height: 45, width: 300, radius: 20,),
          ),
        ],
      ),
    );
  }
}
