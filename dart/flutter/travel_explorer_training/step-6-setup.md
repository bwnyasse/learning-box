# step-6-setup

Let's plan out Step 6 for adding Firebase and integrating a simple GenAI capability using Firebase's Vertex AI integration with the Dart SDK. This approach will give your students practical experience with Firebase setup and a taste of AI integration.

## Step 6: Firebase Integration with GenAI

### 1. Firebase CLI Setup and Project Creation

First, guide students through setting up Firebase in their project:

```bash
# Install Firebase CLI (if not already installed)
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase in your project
cd travel_explorer_app
firebase init
```

During initialization, they should:
-❯ Select Hosting
-❯ Add Firebase to an existing Google Cloud Platform project
-❯ Accept default file locations
-> Detected an existing Flutter Web codebase in the current directory, should we use this? Yes
-> In which region would you like to host server-side content, if applicable? For them select europe-west1 ( Belgium)
-> Set up automatic builds and deploys with GitHub? No

We will have :
```bash
i  Writing configuration info to firebase.json...
i  Writing project information to .firebaserc...
```

### 2. Adding Firebase to Flutter App

Next, they'll add the Firebase Flutter SDK:

```bash
# Add Firebase core
fvm flutter pub add firebase_core

# Add firebase On vertexai
fvm flutter pub add firebase_vertexai
```

Update the Android configuration:

Get your Cloud project id or firebase project id
```bash
# Configure Firebase for Flutter
flutterfire configure --project=your-project-id
```

Which platforms should your configuration support (use arrow keys & space to select)? ›
-> Only select web for the workshop

Example output on my project :

```bash
travel_explorer_app(training-step-5-setup) ✗: flutterfire configure --project=learning-box-262819
i Found 6 Firebase projects. Selecting project learning-box-262819.                      
? Which platforms should your configuration support (use arrow keys & space to select)? ›
✔ Which platforms should your configuration support (use arrow keys & space to select)? · web 
i Firebase web app travel_explorer (web) is not registered on Firebase project learning-box-262819.
i Registered a new Firebase web app on Firebase project learning-box-262819.             

Firebase configuration file lib/firebase_options.dart generated successfully with the following Firebase apps:

Platform  Firebase App Id
web       1:390979335833:web:989a44fee48432de37ea08

Learn more about using this file and next steps from the documentation:
 > https://firebase.google.com/docs/flutter/setup
```

This will generate the necessary configuration files for each platform.

### 3. Initialize Firebase in Flutter App

Update the `main.dart` file to initialize Firebase:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}
```

### 4. Minimal service for accessing Gemini through Firebase Vertex AI

```dart
// lib/modules/genai/repositories/genai_repository.dart
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/foundation.dart';

class GenAIRepository {
  static const String _modelName = 'gemini-2.0-flash';
  GenerativeModel? _model;

  // Initialize the model
  Future<void> initialize() async {
    if (_model != null) return;

    try {
      debugPrint('Initializing Gemini model with $_modelName');
      _model = FirebaseVertexAI.instance.generativeModel(model: _modelName);
    } catch (e) {
      debugPrint('Error initializing Gemini model: $e');
      _model = null;
      rethrow;
    }
  }

  // Generate a description for a location
  Future<String> generateLocationDescription(
      String locationName, String locationType) async {
    if (_model == null) {
      await initialize();
    }

    if (_model == null) {
      throw Exception('Gemini model not initialized');
    }

    try {
      final prompt = _createPrompt(locationName, locationType);

      final response = await _model!.generateContent([
        Content.text(prompt),
      ]);

      if (response.text == null) {
        throw Exception('Empty response from Gemini');
      }

      return _cleanMarkdownText(response.text!);
    } catch (e) {
      debugPrint('Error generating location description: $e');
      throw Exception('Failed to generate description: $e');
    }
  }

  // Create a prompt for the location description
  String _createPrompt(String locationName, String locationType) {
    return '''
    Generate a short, engaging travel description (50-70 words) for a $locationType called "$locationName". 
    Include 1-2 interesting facts and why a traveler might want to visit.
    Be specific and descriptive without being too verbose.
    Do not use markdown formatting.
    ''';
  }

  String _cleanMarkdownText(String markdown) {
    // Implementation remains the same as current AIService
    var cleaned = markdown.replaceAll(RegExp(r'#{1,6}\s.*\n'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\*\*|__|\*|_'), '');
    cleaned = cleaned.replaceAll(RegExp(r'```[\s\S]*?```'), '');
    cleaned = cleaned.replaceAll(RegExp(r'`[^`]*`'), '');
    cleaned = cleaned.replaceAll(RegExp(r'^\s*[-*+]\s+', multiLine: true), '');
    cleaned = cleaned.replaceAll(RegExp(r'^\s*\d+\.\s+', multiLine: true), '');
    cleaned = cleaned.replaceAll(RegExp(r'\[([^\]]*)\]\([^\)]*\)'), r'$1');
    cleaned = cleaned.replaceAll(RegExp(r'^\s*[-*_]{3,}\s*'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ');
    return cleaned.trim();
  }
}
```

### 6. Register the repository in your module:

```dart
// lib/modules/genai/genai_module.dart
import 'package:flutter_modular/flutter_modular.dart';
import 'repositories/genai_repository.dart';

class GenAIModule extends Module {
  @override
  void exportedBinds(i) {
    // Register GenAIRepository as a singleton
    i.addSingleton<GenAIRepository>(GenAIRepository.new);
  }
}
```

### 7. Add the module to your MapModule:

```dart
@override
List<Module> get imports => [GenAIModule()];
```

and ensure to have a multi provider 

```dart
MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                MapBloc(mapRepository: Modular.get<MapRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                GenAIBloc(repository: Modular.get<GenAIRepository>()),
          ),
        ],
```
### 8. Create GenAI State Management

Create a state management solution for the GenAI feature:

```dart
// lib/modules/genai/bloc/genai_state.dart
import 'package:equatable/equatable.dart';

enum GenAIStatus { initial, loading, success, error }

class GenAIState extends Equatable {
  final GenAIStatus status;
  final String? description;
  final String? errorMessage;

  const GenAIState({
    this.status = GenAIStatus.initial,
    this.description,
    this.errorMessage,
  });

  GenAIState copyWith({
    GenAIStatus? status,
    String? description,
    String? errorMessage,
  }) {
    return GenAIState(
      status: status ?? this.status,
      description: description ?? this.description,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, description, errorMessage];
}
```

```dart
// lib/modules/genai/bloc/genai_event.dart
import 'package:equatable/equatable.dart';

abstract class GenAIEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GenerateLocationDescription extends GenAIEvent {
  final String locationName;
  final String locationType;

  GenerateLocationDescription({
    required this.locationName,
    required this.locationType,
  });

  @override
  List<Object?> get props => [locationName, locationType];
}

class ClearDescription extends GenAIEvent {}
```

```dart
// lib/modules/genai/bloc/genai_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/genai_repository.dart';
import 'genai_event.dart';
import 'genai_state.dart';

class GenAIBloc extends Bloc<GenAIEvent, GenAIState> {
  final GenAIRepository _repository;

  GenAIBloc({required GenAIRepository repository})
      : _repository = repository,
        super(const GenAIState()) {
    on<GenerateLocationDescription>(_onGenerateLocationDescription);
    on<ClearDescription>(_onClearDescription);
  }

  Future<void> _onGenerateLocationDescription(
    GenerateLocationDescription event,
    Emitter<GenAIState> emit,
  ) async {
    emit(state.copyWith(status: GenAIStatus.loading));
    
    try {
      final description = await _repository.generateLocationDescription(
        event.locationName,
        event.locationType,
      );
      
      emit(state.copyWith(
        status: GenAIStatus.success,
        description: description,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GenAIStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onClearDescription(
    ClearDescription event,
    Emitter<GenAIState> emit,
  ) {
    emit(const GenAIState());
  }
}
```

### 8. Update Location Details to Include AI-Generated Description

Modify the location details widget to include the AI-generated description:

- Ensure now it is a stateful widget
- Retrieve the bloc in the initState 

```dart
// Update in lib/modules/map/widgets/location_details_content.dart

// Add imports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:travel_explorer/modules/genai/bloc/genai_bloc.dart';
import 'package:travel_explorer/modules/genai/bloc/genai_event.dart';
import 'package:travel_explorer/modules/genai/bloc/genai_state.dart';

// Inside your build method, after the existing description
if (location.description != null) ...[
  Text(
    location.description!,
    style: TextStyle(
      color: Colors.white.withOpacity(0.9),
    ),
  ),
  const SizedBox(height: 16.0),
],

// Add AI description section 
BlocBuilder<GenAIBloc, GenAIState>(
  builder: (context, state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'AI Travel Insight',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            if (state.status != GenAIStatus.loading)
              IconButton(
                icon: const Icon(Icons.psychology,
                    color: Colors.white),
                onPressed: () {
                  _genAIBloc.add(
                    GenerateLocationDescription(
                      locationName:
                          widget.location.name,
                      locationType: widget.location.type
                          .toString()
                          .split('.')
                          .last,
                    ),
                  );
                },
                tooltip: 'Generate AI description',
              ),
          ],
        ),
        const SizedBox(height: 8.0),
        if (state.status == GenAIStatus.loading)
          const Center(
            child: CircularProgressIndicator(),
          )
        else if (state.status == GenAIStatus.success &&
            state.description != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white24),
            ),
            child: Text(
              state.description!,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        else if (state.status == GenAIStatus.error)
          Text(
            'Error: ${state.errorMessage}',
            style: const TextStyle(
                color: Colors.redAccent),
          )
        else
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white12),
            ),
            child: const Text(
              'Tap the AI icon to generate a travel insight about this location.',
              style: TextStyle(color: Colors.white70),
            ),
          ),
      ],
    );
  },
),
```

### Workshop Teaching Points

Here are the key concepts to cover in this Firebase and GenAI integration workshop:

1. **Firebase Setup**
   - Using Firebase CLI
   - Project configuration
   - Platform-specific setup

2. **Firebase Services**
   - Firebase Core initialization
   - Firebase Functions
   - Security rules and best practices

3. **GenAI Integration**
   - Introduction to Vertex AI
   - Prompt engineering basics
   - Firebase Functions as API gateway

4. **State Management for AI Features**
   - Handling async data
   - Loading states
   - Error handling

5. **User Experience**
   - Integrating AI features naturally
   - Providing feedback during processing
   - Error recovery

This approach gives students hands-on experience with Firebase while adding an exciting AI capability to the app. The GenAI feature adds value to the travel app by providing interesting insights about locations without requiring extensive modifications to your existing code.