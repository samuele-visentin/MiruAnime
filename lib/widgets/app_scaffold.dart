import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miru_anime/constants/app_colors.dart';
import 'package:miru_anime/pages/search_page/search_page.dart';
import 'package:miru_anime/utils/transition.dart';
import 'package:miru_anime/pages/drawer_page/drawer.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final String route;
  const AppScaffold({Key? key, required this.route, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawerMenu(
        route: route,
      ),
      body: SafeArea(
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
            icon: const Icon(FontAwesomeIcons.bars, color: AppColors.purple,),
            splashRadius: 25,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (_,__,___) => const SearchPage(),
                  transitionsBuilder: transitionBuilder
                )
              );
            },
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.all(Radius.circular(16))
              ),
              height: 45,
              width: 275,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 15, left: 15),
                    child: Icon(
                      FontAwesomeIcons.magnifyingGlass,
                      color: AppColors.purple,
                      size: 22,
                    ),
                  ),
                  Text(
                    'Cerca un titolo...',
                    style: Theme.of(context).textTheme.subtitle1!.apply(
                      color: Colors.black,
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

