import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_web_search_and_conversation/src/platform_view_registry.dart';

// Unique identifier for the search widget container
const String viewTypeId = 'search-widget-container';

void main() {
  // Register the view factory for the search widget container
  platformViewRegistry.registerViewFactory(
    viewTypeId,
    (int viewId) {
      // Create an input element that triggers the search widget Books
      final inputBooks = html.InputElement()
        ..id = 'searchWidgetTriggerBooks'
        ..style.display = 'none'; // Hide the input element
      // Create an input element that triggers the search widget Books
      final inputWebsites = html.InputElement()
        ..id = 'searchWidgetTriggerWebsites'
        ..style.display = 'none'; // Hide the input element
      // Return a div element that contains the input
      return html.DivElement()
        ..append(inputBooks)
        ..append(inputWebsites);
    },
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter and Vertex AI Search and Conversation'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // This centers the Column's content vertically.
            children: [
              const SizedBox(
                height: 0, // Specify the height
                width: 0, // Specify the width
                child: HtmlElementView(viewType: viewTypeId),
              ),
              // Button for launching a search for books
              FloatingActionButton.extended(
                onPressed: () {
                  // Programmatically click the hidden input element to trigger the search widget
                  html.querySelector('#searchWidgetTriggerBooks')?.click();
                },
                icon: const Icon(Icons.book),
                label: const Text('Search Books'),
              ),
              const SizedBox(height: 20), // Spacing between the buttons
              // Button for exploring websites
              FloatingActionButton.extended(
                onPressed: () {
                  // Implement your functionality for exploring websites here
                  html.querySelector('#searchWidgetTriggerWebsites')?.click();
                },
                icon: const Icon(Icons.explore),
                label: const Text('Explore Websites'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
