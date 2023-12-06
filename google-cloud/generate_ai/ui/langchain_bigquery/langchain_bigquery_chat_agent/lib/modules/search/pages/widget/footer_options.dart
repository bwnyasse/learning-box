import 'package:flutter/material.dart';

class FooterOptions extends StatelessWidget {
  const FooterOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26, width: 0.1),
        color: Colors.black.withOpacity(0.05),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    top: 8,
                  ),
                  child: Text(
                    'Learning Sandbox for Datavalet',
                    style: TextStyle(fontSize: 15, fontFamily: 'arial'),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.black.withOpacity(0.1),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'LangChain',
                    style: TextStyle(fontSize: 15, fontFamily: 'arial'),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: const Text(
                      'GPT',
                      style: TextStyle(fontSize: 15, fontFamily: 'arial'),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: const Text(
                      'Vertex AI',
                      style: TextStyle(fontSize: 15, fontFamily: 'arial'),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: const Text(
                      'Big Query',
                      style: TextStyle(fontSize: 15, fontFamily: 'arial'),
                    ),
                  ),
                ]..insert(4, const Spacer()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
