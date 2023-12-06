import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MenuOptions extends StatelessWidget {
  const MenuOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            margin:
                const EdgeInsets.only(left: 10, right: 10, top: 13, bottom: 13),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Background color
                foregroundColor: Colors.black, // Text color
              ),
              icon: SvgPicture.asset(
                "images/google.svg",
                width: 16,
              ),
              label: const Text('Sign in with Google'),
              onPressed: () async {

              },
            ),
          )
        ],
      ),
    );
  }
}
