Let's implement Step 2 - Interactive Maps for Android. This step will focus on integrating Google Maps and implementing advanced map features in a modular way.

## Step 2: Interactive Maps

### 1. Add dependencies

First, let's add the necessary packages:

```bash
fvm flutter pub add google_maps_flutter google_maps_flutter_web
fvm flutter pub add location
fvm flutter pub add flutter_bloc
fvm flutter pub add equatable
fvm flutter pub add freezed_annotation json_annotation
fvm flutter pub add --dev build_runner freezed json_serializable
```

### 2. Configure Android settings

Update `android/app/src/main/AndroidManifest.xml` to add the required permissions and API key:

```xml
<manifest ...>
    <!-- Add these permissions -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    
    <application ...>
        <!-- Add this meta-data tag for Google Maps -->
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="GOOGLE_MAPS_API_KEY" />
        ...
    </application>
</manifest>
```

Update `web/index.html` to load the Google Maps JavaScript API, like so :

```html
<head>

  <!-- // Other stuff -->

  <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&libraries=drawing,visualization,places"></script>
  <!-- // Marker clustering # -->
  <script src="https://cdn.jsdelivr.net/npm/@googlemaps/markerclusterer@2.5.3/dist/index.umd.min.js"></script>
</head>
```

For the workshop, you can use a test API key or instruct students to obtain their own through the Google Cloud Console.

### 3. Create Location Models

Enhance our location model in `lib/shared/models/location_model.dart`:

```dart
// lib/shared/models/location_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_model.freezed.dart';
part 'location_model.g.dart';

enum LocationType {
  @JsonValue('restaurant')
  restaurant,
  
  @JsonValue('hotel')
  hotel,
  
  @JsonValue('attraction')
  attraction,
  
  @JsonValue('landmark')
  landmark,
  
  @JsonValue('other')
  other
}

@freezed
abstract class LocationModel with _$LocationModel {
  const factory LocationModel({
    required String id,
    required String name,
    required double latitude,
    required double longitude,
    required LocationType type,
    String? description,
    String? imageUrl,
    double? rating,
  }) = _LocationModel;

  factory LocationModel.fromJson(Map<String, dynamic> json) => _$LocationModelFromJson(json);
}
```

### 4. Create Map Repository with JSON Asset Loading

First, create a JSON file in your assets folder:

```sh
mkdir -p assets/data
touch assets/data/locations.json
```

Add the following content to `assets/data/locations.json`:

```json
[
  {
    "id": "1",
    "name": "Eiffel Tower",
    "latitude": 48.8584,
    "longitude": 2.2945,
    "type": "landmark",
    "description": "Famous metal tower in Paris",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/8/85/Tour_Eiffel_Wikimedia_Commons_%28cropped%29.jpg/800px-Tour_Eiffel_Wikimedia_Commons_%28cropped%29.jpg",
    "rating": 4.8
  },
  {
    "id": "2",
    "name": "Louvre Museum",
    "latitude": 48.8606,
    "longitude": 2.3376,
    "type": "attraction",
    "description": "World's largest art museum in Paris",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/6/66/Louvre_Museum_Wikimedia_Commons.jpg/800px-Louvre_Museum_Wikimedia_Commons.jpg",
    "rating": 4.7
  },
  {
    "id": "3",
    "name": "Le Jules Verne",
    "latitude": 48.8583,
    "longitude": 2.2944,
    "type": "restaurant",
    "description": "Upscale restaurant in the Eiffel Tower",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2d/Le_Jules_Verne.jpg/800px-Le_Jules_Verne.jpg",
    "rating": 4.5
  },
  {
    "id": "4",
    "name": "Hotel Plaza Athenee",
    "latitude": 48.8652,
    "longitude": 2.3016,
    "type": "hotel",
    "description": "Luxury hotel in central Paris",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/9/90/H%C3%B4tel_Plaza_Ath%C3%A9n%C3%A9e_Paris.jpg/800px-H%C3%B4tel_Plaza_Ath%C3%A9n%C3%A9e_Paris.jpg",
    "rating": 4.9
  }
]
```

Update your `pubspec.yaml` to include the assets:

```yaml
# Add under flutter section:
assets:
  - assets/data/
```

Create a repository to handle map data in `lib/modules/map/repositories/map_repository.dart`:

```dart
// lib/modules/map/repositories/map_repository.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:travel_explorer/shared/models/location_model.dart';

class MapRepository {
  Future<List<LocationModel>> getLocations() async {
    try {
      // Load json from assets
      final jsonString =
          await rootBundle.loadString('assets/data/locations.json');
      final List<dynamic> jsonData = json.decode(jsonString);

      // Convert JSON to Location models
      return jsonData.map((data) {
        // Convert string type to enum
        final Map<String, dynamic> jsonWithEnumType =
            Map<String, dynamic>.from(data);

        return LocationModel.fromJson(jsonWithEnumType);
      }).toList();
    } catch (e) {
      // Log more details about the error
      print('Error loading locations: $e');
      print('Error details: ${e.toString()}');
      throw Exception('Failed to load locations: $e');
    }
  }
}

```

After creating these files, you'll need to run the build_runner to generate the Freezed and JSON serialization code:

```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```


### 5. Create Map State Management with BLoC

Create map bloc files:

```dart
// lib/modules/map/bloc/map_state.dart
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_explorer/shared/models/location_model.dart';

enum MapStatus { initial, loading, loaded, error }

class MapState extends Equatable {
  final MapStatus status;
  final List<LocationModel> locations;
  final Set<Marker> markers;
  final CameraPosition? cameraPosition;
  final String? errorMessage;
  final LocationModel? selectedLocation;
  
  const MapState({
    this.status = MapStatus.initial,
    this.locations = const [],
    this.markers = const {},
    this.cameraPosition,
    this.errorMessage,
    this.selectedLocation,
  });
  
  MapState copyWith({
    MapStatus? status,
    List<LocationModel>? locations,
    Set<Marker>? markers,
    CameraPosition? cameraPosition,
    String? errorMessage,
    LocationModel? selectedLocation,
  }) {
    return MapState(
      status: status ?? this.status,
      locations: locations ?? this.locations,
      markers: markers ?? this.markers,
      cameraPosition: cameraPosition ?? this.cameraPosition,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedLocation: selectedLocation ?? this.selectedLocation,
    );
  }
  
  @override
  List<Object?> get props => [
    status, 
    locations, 
    markers, 
    cameraPosition, 
    errorMessage,
    selectedLocation
  ];
}
```

```dart
// lib/modules/map/bloc/map_event.dart
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_explorer/shared/models/location_model.dart';

abstract class MapEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadLocations extends MapEvent {}

class MapCreated extends MapEvent {
  final GoogleMapController controller;
  
  MapCreated(this.controller);
  
  @override
  List<Object?> get props => [controller];
}

class SelectLocation extends MapEvent {
  final LocationModel location;
  
  SelectLocation(this.location);
  
  @override
  List<Object?> get props => [location];
}

class CameraPositionChanged extends MapEvent {
  final CameraPosition position;
  
  CameraPositionChanged(this.position);
  
  @override
  List<Object?> get props => [position];
}
```

```dart
// lib/modules/map/bloc/map_bloc.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_explorer/modules/map/bloc/map_event.dart';
import 'package:travel_explorer/modules/map/bloc/map_state.dart';
import 'package:travel_explorer/modules/map/repositories/map_repository.dart';
import 'package:travel_explorer/shared/models/location_model.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapRepository _mapRepository;
  GoogleMapController? _mapController;
  
  MapBloc({required MapRepository mapRepository}) 
      : _mapRepository = mapRepository,
        super(MapState(
          cameraPosition: const CameraPosition(
            target: LatLng(48.8566, 2.3522), // Paris
            zoom: 12,
          )
        )) {
    on<LoadLocations>(_onLoadLocations);
    on<MapCreated>(_onMapCreated);
    on<SelectLocation>(_onSelectLocation);
    on<CameraPositionChanged>(_onCameraPositionChanged);
  }
  
  Future<void> _onLoadLocations(
    LoadLocations event, 
    Emitter<MapState> emit
  ) async {
    emit(state.copyWith(status: MapStatus.loading));
    try {
      final locations = await _mapRepository.getLocations();
      final markers = _createMarkers(locations);
      
      emit(state.copyWith(
        status: MapStatus.loaded,
        locations: locations,
        markers: markers,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: MapStatus.error,
        errorMessage: 'Failed to load locations: ${error.toString()}',
      ));
    }
  }
  
  void _onMapCreated(
    MapCreated event, 
    Emitter<MapState> emit
  ) {
    _mapController = event.controller;
  }
  
  void _onSelectLocation(
    SelectLocation event, 
    Emitter<MapState> emit
  ) {
    final newCameraPosition = CameraPosition(
      target: LatLng(event.location.latitude, event.location.longitude),
      zoom: 15,
    );
    
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(newCameraPosition)
    );
    
    emit(state.copyWith(
      cameraPosition: newCameraPosition,
      selectedLocation: event.location,
    ));
  }
  
  void _onCameraPositionChanged(
    CameraPositionChanged event, 
    Emitter<MapState> emit
  ) {
    emit(state.copyWith(cameraPosition: event.position));
  }
  
  Set<Marker> _createMarkers(List<LocationModel> locations) {
    return locations.map((location) {
      return Marker(
        markerId: MarkerId(location.id),
        position: LatLng(location.latitude, location.longitude),
        infoWindow: InfoWindow(
          title: location.name,
          snippet: location.description,
        ),
        onTap: () => add(SelectLocation(location)),
      );
    }).toSet();
  }
}
```

### 6. Update Map Module

Update the map module to include the repository and bloc:

```dart
// lib/modules/map/map_module.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:travel_explorer/modules/map/bloc/map_bloc.dart';
import 'package:travel_explorer/modules/map/repositories/map_repository.dart';
import 'package:travel_explorer/modules/map/pages/map_page.dart';

class MapModule extends Module {
  @override
  void binds(i) {
    // Register MapRepository as a singleton
    i.addSingleton<MapRepository>(MapRepository.new);
  }

  @override
  void routes(r) {
    r.child(
      Modular.initialRoute,
      child: (_) => BlocProvider(
        create: (_) => MapBloc(mapRepository: Modular.get<MapRepository>()),
        child: const MapPage(),
      ),
    );
  }
}
```

### 7. Implement Map Page

Create an enhanced map page with the map view and location list:

```dart
// lib/modules/map/pages/map_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_explorer/modules/map/bloc/map_bloc.dart';
import 'package:travel_explorer/modules/map/bloc/map_event.dart';
import 'package:travel_explorer/modules/map/bloc/map_state.dart';
import 'package:travel_explorer/shared/models/location_model.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final MapBloc _mapBloc;

  @override
  void initState() {
    super.initState();
    _mapBloc =  BlocProvider.of<MapBloc>(context);
    _mapBloc.add(LoadLocations());
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _mapBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Explore Map'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            if (state.status == MapStatus.initial ||
                state.status == MapStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == MapStatus.error) {
              return Center(
                  child: Text(state.errorMessage ?? 'An error occurred'));
            }

            return Column(
              children: [
                Expanded(
                  flex: 3,
                  child: GoogleMap(
                    initialCameraPosition: state.cameraPosition!,
                    markers: state.markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: true,
                    mapType: MapType.normal,
                    onMapCreated: (controller) {
                      _mapBloc.add(MapCreated(controller));
                    },
                    onCameraMove: (position) {
                      _mapBloc.add(CameraPositionChanged(position));
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: LocationsList(
                    bloc: _mapBloc,
                    locations: state.locations,
                    selectedLocation: state.selectedLocation,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class LocationsList extends StatelessWidget {
  final List<LocationModel> locations;
  final LocationModel? selectedLocation;
  final MapBloc bloc;

  const LocationsList({
    super.key,
    required this.bloc,
    required this.locations,
    this.selectedLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          color: Theme.of(context).colorScheme.primaryContainer,
          width: double.infinity,
          child: Text(
            'Nearby Locations (${locations.length})',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: locations.length,
            itemBuilder: (context, index) {
              final location = locations[index];
              final isSelected = selectedLocation?.id == location.id;

              return ListTile(
                title: Text(location.name),
                subtitle: Text(location.type.toString().split('.').last),
                trailing: location.rating != null
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          Text(location.rating!.toString()),
                        ],
                      )
                    : null,
                selected: isSelected,
                selectedTileColor: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withOpacity(0.3),
                onTap: () {
                  bloc.add(SelectLocation(location));
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
```


RUN the Application and we take a lot with the instructor 

### 8. Create Custom Marker Icons (Optional Advanced Feature)

To demonstrate custom markers, create a utility class for marker icons:

```dart
// lib/modules/map/utils/marker_utils.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:travel_explorer/shared/models/location_model.dart';

class MarkerUtils {
  static Future<BitmapDescriptor> getMarkerIconForType(LocationType type) async {
    // For a workshop, you could load different icons from assets
    // For simplicity, we'll use colored map pins created with custom markers
    
    final Color markerColor = _getColorForType(type);
    
    return BitmapDescriptor.defaultMarkerWithHue(
      _getHueForColor(markerColor),
    );
  }
  
  static Color _getColorForType(LocationType type) {
    switch (type) {
      case LocationType.restaurant:
        return Colors.red;
      case LocationType.hotel:
        return Colors.blue;
      case LocationType.attraction:
        return Colors.green;
      case LocationType.landmark:
        return Colors.purple;
      case LocationType.other:
        return Colors.orange;
    }
  }
  
  static double _getHueForColor(Color color) {
    if (color == Colors.red) return BitmapDescriptor.hueRed;
    if (color == Colors.blue) return BitmapDescriptor.hueBlue;
    if (color == Colors.green) return BitmapDescriptor.hueGreen;
    if (color == Colors.yellow) return BitmapDescriptor.hueYellow;
    if (color == Colors.purple) return BitmapDescriptor.hueMagenta;
    if (color == Colors.orange) return BitmapDescriptor.hueOrange;
    return BitmapDescriptor.hueRed;
  }
}
```

### 9. Add Location Detail Widget

Create a simple location detail widget that appears when a location is selected:

```dart
// lib/modules/map/widgets/location_details_card.dart
import 'package:flutter/material.dart';
import 'package:travel_explorer/shared/models/location_model.dart';

class LocationDetailsCard extends StatelessWidget {
  final LocationModel location;
  final VoidCallback? onClose;
  
  const LocationDetailsCard({
    super.key,
    required this.location,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              if (location.imageUrl != null) 
                Image.network(
                  location.imageUrl!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onClose,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildTypeChip(location.type),
                    const Spacer(),
                    if (location.rating != null) ...[
                      const Icon(Icons.star, color: Colors.amber),
                      Text(
                        location.rating!.toString(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                if (location.description != null)
                  Text(location.description!),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // To be implemented in later steps
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Adding to trip will be implemented in a later step')),
                    );
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 8),
                      Text('Add to Trip'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTypeChip(LocationType type) {
    final typeLabel = type.toString().split('.').last;
    IconData iconData;
    Color color;
    
    switch (type) {
      case LocationType.restaurant:
        iconData = Icons.restaurant;
        color = Colors.red;
        break;
      case LocationType.hotel:
        iconData = Icons.hotel;
        color = Colors.blue;
        break;
      case LocationType.attraction:
        iconData = Icons.attractions;
        color = Colors.green;
        break;
      case LocationType.landmark:
        iconData = Icons.location_city;
        color = Colors.purple;
        break;
      case LocationType.other:
        iconData = Icons.place;
        color = Colors.orange;
        break;
    }
    
    return Chip(
      avatar: Icon(iconData, color: Colors.white, size: 16),
      label: Text(
        typeLabel,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
  }
}
```

### 10. Update the Map Page to Show Location Details When Selected

Modify the `MapPage` to show the details card when a location is selected:

```dart
// In map_page.dart, update the build method
@override
Widget build(BuildContext context) {
  return BlocProvider.value(
    value: _mapBloc,
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Explore Map'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          if (state.status == MapStatus.initial || 
              state.status == MapStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state.status == MapStatus.error) {
            return Center(child: Text(state.errorMessage ?? 'An error occurred'));
          }
          
          return Stack(
            children: [
              // Map view taking full screen
              GoogleMap(
                initialCameraPosition: state.cameraPosition!,
                markers: state.markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                mapType: MapType.normal,
                onMapCreated: (controller) {
                  _mapBloc.add(MapCreated(controller));
                },
                onCameraMove: (position) {
                  _mapBloc.add(CameraPositionChanged(position));
                },
              ),
              
              // Bottom sheet with locations list
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: LocationsList(
                    locations: state.locations,
                    selectedLocation: state.selectedLocation,
                  ),
                ),
              ),
              
              // Show location details card when a location is selected
              if (state.selectedLocation != null)
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: LocationDetailsCard(
                    location: state.selectedLocation!,
                    onClose: () {
                      // Clear selection
                      _mapBloc.add(const ClearSelection());
                    },
                  ),
                ),
            ],
          );
        },
      ),
    ),
  );
}
```

Add the `ClearSelection` event to your events file:

```dart
// Add to map_event.dart
class ClearSelection extends MapEvent {
  const ClearSelection();
}
```

And handle it in the bloc:

```dart
// Add to map_bloc.dart in the constructor
on<ClearSelection>(_onClearSelection);

// Add this method
void _onClearSelection(
  ClearSelection event, 
  Emitter<MapState> emit
) {
  emit(state.copyWith(selectedLocation: null));
}
```

This implementation demonstrates:
1. Setting up a modular map feature with its own repository, state management, and UI components
2. Creating an interactive map with custom markers
3. Handling location selection and camera movements
4. Displaying location details when selected
5. Organizing everything according to the modular architecture pattern

For the workshop, you can guide students through each step, explaining the concepts as you build this feature together.