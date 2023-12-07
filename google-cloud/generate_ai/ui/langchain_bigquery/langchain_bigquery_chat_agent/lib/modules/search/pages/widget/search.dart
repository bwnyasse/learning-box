import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xterm/xterm.dart';
import 'package:ansi_styles/ansi_styles.dart';

import '../../bloc/search_bloc.dart';
import '../../bloc/search_event.dart';
import '../../bloc/search_state.dart';
import 'terminal_result.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Terminal terminal = Terminal();

  // Variable to hold the selected radio button value
  String _selectedAI = 'open_ai';

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state is SearchErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'images/logo.png',
              height: 100,
            ),
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 20),
            _buildRadioButtons(),
            const SizedBox(height: 20), // Add the radio buttons here
            _buildSearchButton(),
            const SizedBox(height: 20),
            Expanded(
              child: _buildSearchResults(),
            ), // Use Expanded
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: 500,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0.0, 0.5),
            blurRadius: 5.0,
            spreadRadius: 0.3,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: TextField(
          controller: myController,
          cursorColor: Theme.of(context).primaryColor,
          decoration: const InputDecoration(
            hintText: "Enter a prompt and search",
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.0, vertical: 13.0),
          ),
          maxLines: 1,
        ),
      ),
    );
  }

  // Method to build radio buttons
  Widget _buildRadioButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio<String>(
          value: 'open_ai',
          groupValue: _selectedAI,
          onChanged: (String? value) {
            setState(() {
              _selectedAI = value!;
            });
          },
        ),
        const Text('OpenAI'),
        Radio<String>(
          value: 'vertex_ai',
          groupValue: _selectedAI,
          onChanged: (String? value) {
            setState(() {
              _selectedAI = value!;
            });
          },
        ),
        const Text('VertexAI'),
      ],
    );
  }

  Widget _buildSearchButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0, top: 10),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, // Background color
              foregroundColor: Colors.black, // Text color
            ),
            icon: Image.asset("images/search.png", width: 16),
            label: const Text('DataSearch'),
            onPressed: () {
              String value = myController.text;
              if (value.isNotEmpty) {
                BlocProvider.of<SearchBloc>(context).add(SearchLoadEvent(
                  prompt: value,
                  option: _selectedAI, // Use the selected AI value
                ));
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 10),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, // Background color
              foregroundColor: Colors.black, // Text color
            ),
            icon: const Icon(Icons.clear, size: 16),
            label: const Text('Reset'),
            onPressed: () {
              myController.clear(); // Clear the text field
              terminal = Terminal();
              BlocProvider.of<SearchBloc>(context).add(SearchResetEvent());
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is SearchLoadedState) {
          // Assuming state.response is of type SearchOutPut

          final forTerminal = formatForTerminal(state.response.output);

          terminal.write(forTerminal.$2); // Write the output to the terminal

          // Display the terminal using TerminalView
          return TerminalResultWidget(
            terminal: terminal,
            finalAnswer: AnsiStyles.strip(forTerminal.$1),
          );
        } else {
          return const Center(child: Text(''));
        }
      },
    );
  }
}

(String, String) formatForTerminal(String text) {
  // Split the text into lines
  var lines = text.split('\n');

  // Add '\r\n' to the end of each line
  var formattedLines = lines.map((line) => line + '\r\n').toList();

  // Join the lines back into a single string
  return (extractFinalAnswer(text), formattedLines.join());
}

String extractFinalAnswer(String text) {
  // Define a regular expression pattern to capture text between 'Final Answer:' and '> Finished chain.'
  final RegExp regExp = RegExp(r'Final Answer:(.*?)> Finished chain\.',
      dotAll: true); // dotAll: true allows '.' to match newline characters

  // Find the first match in the text
  final match = regExp.firstMatch(text);

  if (match != null && match.groupCount >= 1) {
    // Return the captured group, which is the content between the markers
    return match.group(1)?.trim() ??
        ""; // trim to remove leading/trailing whitespaces
  }

  return ""; // Return an empty string if no match is found
}
