import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miru_anime/app_theme/app_colors.dart';
import 'package:miru_anime/pages/search_page/search_page.dart';
import 'package:miru_anime/pages/drawer_page/drawer.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final String route;
  final ScrollController? scrollController;
  final bool paddingTop;
  const AppScaffold({
    Key? key,
    this.paddingTop = true,
    required this.route,
    required this.child,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawerMenu(
        route: route,
        scrollController: scrollController
      ),
      body: SafeArea(
        top: paddingTop,
        child: Column(
          children: [
            Expanded(child: child),
            const Divider(
              thickness: 2,
              color: AppColors.grey,
              height: 1,
            ),
            const _AppBottomBar()
          ],
        ),
      ),
    );
  }
}

class _AppBottomBar extends StatelessWidget {
  const _AppBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            iconSize: 22,
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(FontAwesomeIcons.bars,
              color: Theme.of(context).colorScheme.secondary),
            splashRadius: 25,
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(SearchPage.route),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(Radius.circular(16))
              ),
              height: 45,
              width: 275,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15, left: 15),
                    child: Icon(
                      FontAwesomeIcons.magnifyingGlass,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 22,
                    ),
                  ),
                  Text(
                    'Cerca un titolo...',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

