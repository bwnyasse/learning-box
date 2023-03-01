import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../cubits/cubit.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';

int currentIndex = 0;

class SideMenuComponent extends StatefulWidget {
  const SideMenuComponent({
    Key? key,
  }) : super(key: key);

  @override
  State<SideMenuComponent> createState() => _SideMenuComponentState();
}

class _SideMenuComponentState extends State<SideMenuComponent> {
  List<Widget> buildMenu() {
    FirebaseRemoteConfigService firebaseRemoteConfigService =
        context.watch<FirebaseRemoteConfigService>();

    if (firebaseRemoteConfigService.isMenuListEnabled()) {
      MenuItemResponse response = firebaseRemoteConfigService.getMenuItems();
      List<Widget> widgets = [];
      for (var element in response.items) {
        if (element.id == 1 &&
                !firebaseRemoteConfigService.isTopRatedEnabled() ||
            element.id == 4 &&
                !firebaseRemoteConfigService.isUpcomingEnabled()) {
          continue;
        }
        widgets.add(
          DrawerListTile(
            isMenuEnabled: firebaseRemoteConfigService.isMenuListEnabled(),
            index: element.id,
            title: element.name,
            svgSrc: "assets/icons/menu_top_rated.svg",
            press: () {
              setState(() {
                currentIndex = element.id;
                BlocProvider.of<AppCubit>(context).onLoadEvent(element.path);
              });
            },
          ),
        );
      }
      return widgets;
    }
    return [
      if (firebaseRemoteConfigService.isTopRatedEnabled())
        DrawerListTile(
          index: 1,
          title: "Top rated",
          svgSrc: "assets/icons/menu_top_rated.svg",
          press: () {
            setState(() {
              currentIndex = 1;
              BlocProvider.of<AppCubit>(context).onLoadEvent('top_rated');
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
            BlocProvider.of<AppCubit>(context).onLoadEvent('now_playing');
          });
        },
      ),
      if (firebaseRemoteConfigService.isUpcomingEnabled())
        DrawerListTile(
          index: 4,
          title: "Upcoming",
          svgSrc: "assets/icons/menu_upcoming.svg",
          press: () {
            setState(() {
              currentIndex = 4;
              BlocProvider.of<AppCubit>(context).onLoadEvent('upcoming');
            });
          },
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    FirebaseRemoteConfigService firebaseRemoteConfigService =
        context.watch<FirebaseRemoteConfigService>();
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Image.asset("assets/images/logo.png"),
                if (firebaseRemoteConfigService.isLocationUsers())
                  getLocationComponent(),
              ],
            ),
          ),
          ...buildMenu(),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.index,
    required this.title,
    required this.svgSrc,
    required this.press,
    this.isMenuEnabled = false,
  }) : super(key: key);
  final int index;
  final String title, svgSrc;
  final VoidCallback press;
  bool isMenuEnabled;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: isMenuEnabled
          ? CircleAvatar(
              radius: 14,
              child: Text("$index"),
            )
          : SvgPicture.asset(
              svgSrc,
              color: (index == currentIndex) ? Colors.blue : Colors.white54,
              height: (index == currentIndex) ? 20 : 16,
            ),
      title: Text(
        title,
        style: TextStyle(
            fontSize: (index == currentIndex) ? 16 : 14,
            color: (index == currentIndex) ? Colors.white : Colors.white54,
            fontWeight:
                (index == currentIndex) ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }
}

Column getLocationComponent() {
  return Column(
    children: [
      const Text(
        "Location tracking isenable  !",
        style: TextStyle(
          color: Colors.yellow,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text("Country : ${LocationService.locationResponse.countryName}"),
      Text("State : ${LocationService.locationResponse.stateProv}"),
    ],
  );
}
