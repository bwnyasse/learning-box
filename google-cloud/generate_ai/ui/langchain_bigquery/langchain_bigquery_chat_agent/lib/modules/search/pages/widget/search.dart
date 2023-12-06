import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animated_tree_view/animated_tree_view.dart';

import '../../bloc/search_bloc.dart';
import '../../bloc/search_event.dart';
import '../../bloc/search_state.dart';
import '../../models/model.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/logo.png',
                height: 100,
              ),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 20),
              _buildSearchButton(),
              const SizedBox(height: 20),
              Expanded(
                  child: Center(child: _buildSearchResults())), // Use Expanded
            ],
          ),
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
                BlocProvider.of<SearchBloc>(context)
                    .add(SearchLoadEvent(prompt: value));
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
          return ListView.builder(
            itemCount:
                state.response.ai.length + 1, // Add 1 for the finalAnswer
            itemBuilder: (context, index) {
              if (index == state.response.ai.length) {
                // Special item for finalAnswer
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.green, // Set the card color to green
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Final answer => ${state.response.finalAnswer}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ),
                );
              } else {
                // Subtract 1 from index because the first item is finalAnswer
                AIResponse aiResponse = state.response.ai[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 2,
                    child: ListTile(
                      title: Text("Thought: ${aiResponse.thought}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (aiResponse.action != null &&
                                aiResponse.action!.isNotEmpty)
                              Text('Action: ${aiResponse.action}',
                                  style: TextStyle(color: Colors.grey[600])),
                            if (aiResponse.action != null &&
                                aiResponse.action!.isNotEmpty)
                              const SizedBox(height: 4),
                            if (aiResponse.actionInput != null &&
                                aiResponse.actionInput!.isNotEmpty)
                              Text('Action Input: ${aiResponse.actionInput}',
                                  style: TextStyle(color: Colors.grey[600])),
                            if (aiResponse.actionInput != null &&
                                aiResponse.actionInput!.isNotEmpty)
                              const SizedBox(height: 4),
                            // Add other items in a similar manner
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          );
        } else {
          return const Center(child: Text(''));
        }
      },
    );
  }
}
