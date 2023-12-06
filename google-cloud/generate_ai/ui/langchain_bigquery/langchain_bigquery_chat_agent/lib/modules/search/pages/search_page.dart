
import 'package:flutter/material.dart';

import 'widget/footer_options.dart';
import 'widget/menu_options.dart';
import 'widget/search.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Flexible(
              flex: 1,
              child: MenuOptions(),
            ),
            Flexible(
              flex: 8,
              child: Search(),
            ),
            Flexible(
              flex: 1,
              child: FooterOptions(),
            ),
          ],
        ));
  }
}