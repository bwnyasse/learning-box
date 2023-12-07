import 'package:flutter/material.dart';
import 'package:xterm/xterm.dart';

class TerminalResultWidget extends StatefulWidget {
  final String finalAnswer;
  final Terminal terminal;

  const TerminalResultWidget({
    super.key,
    required this.finalAnswer,
    required this.terminal,
  });

  @override
  TerminalResultWidgetState createState() => TerminalResultWidgetState();
}

class TerminalResultWidgetState extends State<TerminalResultWidget> {
  bool isTerminalVisible =
      false; // State to control the visibility of the terminal

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: Colors.green,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.finalAnswer,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          icon: const Icon(
            Icons.computer,
            size: 16.0,
          ),
          onPressed: () {
            setState(() {
              isTerminalVisible = !isTerminalVisible;
            });
          },
          label: Text(isTerminalVisible
              ? 'Hide Terminal Output'
              : 'Show Terminal Output'),
        ),
        const SizedBox(height: 20),
        if (isTerminalVisible)
          Container(
            height: 250, // Set a fixed height for the terminal
            padding: const EdgeInsets.all(8.0),
            child: TerminalView(widget.terminal),
          ),
      ],
    );
  }
}
