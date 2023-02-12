import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../cubits/cubit.dart';
import '../../../services/impl/location_service.dart';
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
                Text(
                    "Country : ${LocationService.locationResponse.countryName}"),
                Text("City : ${LocationService.locationResponse.state}"),
                if (firebaseRemoteConfigService.getLocationUsers())
                  const Text(
                    "Region enable for this feature !",
                    style: TextStyle(
                      color: Colors.yellow,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          if (firebaseRemoteConfigService.getTopRatedEnabled())
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
          if (firebaseRemoteConfigService.getUpcomingEnabled())
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
