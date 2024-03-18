import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_web_search_and_conversation/src/platform_view_registry.dart';

// Unique identifier for the search widget container
const String viewTypeId = 'search-widget-container';
const String inputForBooks = 'searchWidgetTriggerBooks';
const String inputForWebsites = 'searchWidgetTriggerWebsites';

// Entry point for the application
void main() {
  // Register the view factory for the search widget container
  platformViewRegistry.registerViewFactory(
    viewTypeId,
    (int viewId) {
      // Create and return a div element that contains the input elements
      return html.DivElement()
        ..append(_createInputElement(inputForBooks))
        ..append(_createInputElement(inputForWebsites));
    },
  );

  runApp(MyApp());
}

// Utility function to create a hidden input element
html.InputElement _createInputElement(String id) {
  return html.InputElement()
    ..id = id
    ..style.display = 'none'; // Hide the input element
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
            mainAxisSize: MainAxisSize.min, // This centers the Column's content vertically.
            children: [
              const SizedBox(
                height: 0, // Specify the height
                width: 0, // Specify the width
                child: HtmlElementView(viewType: viewTypeId),
              ),
              // Button for launching a search for books
              FloatingActionButton.extended(
                onPressed: () => _triggerSearch(inputForBooks),
                icon: const Icon(Icons.book),
                label: const Text('Search Books'),
              ),
              const SizedBox(height: 20), // Spacing between the buttons
              // Button for exploring websites
              FloatingActionButton.extended(
                onPressed: () => _triggerSearch(inputForWebsites),
                icon: const Icon(Icons.explore),
                label: const Text('Explore Websites'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Utility function to trigger the search widget
  void _triggerSearch(String triggerId) {
    html.querySelector('#$triggerId')?.click();
  }
}
