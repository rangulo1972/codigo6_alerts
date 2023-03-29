import 'package:alerts/domain/routes/routes.dart';
import 'package:alerts/presentation/general/ui/colors.dart';
import 'package:alerts/presentation/pages/home_page.dart';
import 'package:alerts/presentation/pages/map_page.dart';
import 'package:alerts/presentation/pages/news_page.dart';
import 'package:alerts/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InitPage extends StatefulWidget {
  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  int indexPage = 0;
  List<Widget> pages = [
    HomePage(),
    MapPage(),
    NewsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[indexPage],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kBrandSecondaryColor.withOpacity(0.4),
        elevation: 0,
        onTap: (value) {
          indexPage = value;
          setState(() {});
        },
        type: BottomNavigationBarType.fixed,
        currentIndex: indexPage,
        iconSize: 24,
        selectedFontSize: 16,
        selectedItemColor: kBrandPrimaryColor,
        selectedIconTheme: IconThemeData(size: 24),
        unselectedFontSize: 14,
        unselectedItemColor: Colors.black38,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              IconsAssets.iconHome,
              color: indexPage == 0 ? kBrandPrimaryColor : Colors.black45,
            ),
            label: "Inicio",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              IconsAssets.iconMap,
              color: indexPage == 1 ? kBrandPrimaryColor : Colors.black45,
            ),
            label: "Mapa",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              IconsAssets.iconNews,
              color: indexPage == 2 ? kBrandPrimaryColor : Colors.black45,
            ),
            label: "Noticias",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              IconsAssets.iconUser,
              color: indexPage == 3 ? kBrandPrimaryColor : Colors.black45,
            ),
            label: "perfil",
          ),
        ],
      ),
    );
  }
}
