import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

int currentIndex = 0;

class SideMenu extends StatefulWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            index: 0,
            title: "Latest",
            svgSrc: "assets/icons/menu_latest.svg",
            press: () {
              setState(() {
                currentIndex = 0;
              });
            },
          ),
          DrawerListTile(
            index: 1,
            title: "Top rated",
            svgSrc: "assets/icons/menu_top_rated.svg",
            press: () {
              setState(() {
                currentIndex = 1;
              });
            },
          ),
          DrawerListTile(
            index: 3,
            title: "Now Playing",
            svgSrc: "assets/icons/menu_now_playing.svg",
            press: () {
              setState(() {
                currentIndex = 3;
              });
            },
          ),
          DrawerListTile(
            index: 5,
            title: "Upcoming",
            svgSrc: "assets/icons/menu_upcoming.svg",
            press: () {
              setState(() {
                currentIndex = 5;
              });
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.index,
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);
  final int index;
  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(
            color: (index == currentIndex) ? Colors.white : Colors.white54,
            fontWeight:
                (index == currentIndex) ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }
}
