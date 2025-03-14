# step-3-setup

Let's implement these four key custom widget components and integrate them into your existing code structure. I'll focus on creating reusable components that you can use in your map interface.

## 1. Implement CustomPainter Widget

First, let's create a circular rating painter for displaying location ratings:

```dart
// lib/shared/widgets/custom_painters/circular_rating_painter.dart
import 'dart:math';
import 'package:flutter/material.dart';

class CircularRatingPainter extends CustomPainter {
  final double rating;
  final double maxRating;
  final Color backgroundColor;
  final Color foregroundColor;
  final double strokeWidth;

  CircularRatingPainter({
    required this.rating,
    this.maxRating = 5.0,
    this.backgroundColor = Colors.grey,
    this.foregroundColor = Colors.amber,
    this.strokeWidth = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - strokeWidth / 2;
    
    // Paint for background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    
    // Paint for rating arc
    final ratingPaint = Paint()
      ..color = foregroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    
    // Draw background circle
    canvas.drawCircle(center, radius, backgroundPaint);
    
    // Draw rating arc
    final ratingAngle = 2 * pi * (rating / maxRating);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / The value of pi is approximately 3.14159 but we subtract 2, pi / 2 (or -90 degrees),
      ratingAngle,
      false,
      ratingPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CircularRatingIndicator extends StatelessWidget {
  final double rating;
  final double size;
  final Color backgroundColor;
  final Color foregroundColor;
  final double strokeWidth;
  final Widget? child;

  const CircularRatingIndicator({
    super.key,
    required this.rating,
    this.size = 60.0,
    this.backgroundColor = Colors.grey,
    this.foregroundColor = Colors.amber,
    this.strokeWidth = 8.0,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Rating circle
          CustomPaint(
            painter: CircularRatingPainter(
              rating: rating,
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              strokeWidth: strokeWidth,
            ),
            size: Size(size, size),
          ),
          // Child widget (usually text showing the rating)
          if (child != null) child!,
        ],
      ),
    );
  }
}
```

## 2. Create BoxDecoration Components

Now, let's create a fancy card with BoxDecoration:

```dart
// lib/shared/widgets/decorations/fancy_card.dart
import 'package:flutter/material.dart';

class FancyCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final List<Color> gradientColors;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const FancyCard({
    super.key,
    required this.child,
    this.borderRadius = 16.0,
    this.gradientColors = const [Colors.blue, Colors.purple],
    this.height,
    this.width,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.all(8.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: gradientColors.first.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
```

## 3. Create a Rotated Label Widget

Let's implement vertical text labels using RotatedBox:

```dart
// lib/shared/widgets/rotated_label.dart
import 'package:flutter/material.dart';

class VerticalLabel extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color backgroundColor;
  final double padding;

  const VerticalLabel({
    super.key,
    required this.text,
    this.style,
    this.backgroundColor = Colors.transparent,
    this.padding = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.titleMedium;
    final textStyle = style ?? defaultStyle?.copyWith(
      fontWeight: FontWeight.bold,
    );

    return Container(
      padding: EdgeInsets.all(padding),
      color: backgroundColor,
      child: RotatedBox(
        quarterTurns: 3, // Rotate 270 degrees (counter-clockwise)
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}

class NewBadge extends StatelessWidget {
  final double size;
  final Color color;
  
  const NewBadge({
    super.key,
    this.size = 60.0,
    this.color = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1, // 90 degrees clockwise
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          // Create a triangle shape
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(4.0),
          ),
        ),
        child: const RotatedBox(
          quarterTurns: -1, // -90 degrees to make text horizontal again
          child: Text(
            'NEW',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
```

## 4. Create Glass Morphism Effect with Opacity

```dart
// lib/shared/widgets/glass_container.dart
import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blurAmount;
  final Color tintColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const GlassContainer({
    super.key,
    required this.child,
    this.blurAmount = 5.0,
    this.tintColor = Colors.white,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurAmount,
          sigmaY: blurAmount,
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: tintColor.withOpacity(0.2),
            border: Border.all(
              color: tintColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
```

## Integration: Enhance Location Details Content

Now, let's enhance your existing `location_details_content.dart` to use these custom widgets:

```dart
// lib/modules/map/widgets/location_details_content.dart
import 'package:flutter/material.dart';
import 'package:travel_explorer/shared/models/location_model.dart';
import 'package:travel_explorer/shared/widgets/custom_painters/circular_rating_painter.dart';
import 'package:travel_explorer/shared/widgets/decorations/fancy_card.dart';
import 'package:travel_explorer/shared/widgets/glass_container.dart';
import 'package:travel_explorer/shared/widgets/rotated_label.dart';

class LocationDetailsContent extends StatelessWidget {
  final LocationModel location;
  final VoidCallback? onAddToTrip;
  final bool isNew;

  const LocationDetailsContent({
    super.key,
    required this.location,
    this.onAddToTrip,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FancyCard(
          gradientColors: _getGradientForType(location.type),
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image section with glass overlay for details
              Stack(
                children: [
                  // Location image
                  if (location.imageUrl != null)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16.0),
                      ),
                      child: Image.network(
                        location.imageUrl!,
                        height: 450,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Container(
                      height: 180,
                      color: _getColorForType(location.type).withOpacity(0.3),
                      child: Center(
                        child: Icon(
                          _getIconForType(location.type),
                          size: 60,
                          color: _getColorForType(location.type),
                        ),
                      ),
                    ),
                    
                  // Category badge
                  Positioned(
                    left: 0,
                    top: 20,
                    child: VerticalLabel(
                      text: location.type.toString().split('.').last.toUpperCase(),
                      backgroundColor: _getColorForType(location.type),
                      padding: 12,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  // Glass effect info bar at bottom of image
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: GlassContainer(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      borderRadius: 0,
                      blurAmount: 3,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              location.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                shadows: [
                                  Shadow(
                                    color: Colors.black45,
                                    blurRadius: 2,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (location.rating != null)
                            CircularRatingIndicator(
                              rating: location.rating!,
                              size: 50.0,
                              strokeWidth: 3.0,
                              foregroundColor: Colors.amber,
                              backgroundColor: Colors.white54,
                              child: Text(
                                location.rating!.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              // Details section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (location.description != null) ...[
                      Text(
                        location.description!,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                    
                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          icon: Icons.map,
                          label: 'View on Map',
                          onPressed: () {
                            // Already on map for now
                          },
                        ),
                        _buildActionButton(
                          icon: Icons.add,
                          label: 'Add to Trip',
                          onPressed: onAddToTrip,
                        ),
                        _buildActionButton(
                          icon: Icons.favorite_border,
                          label: 'Favorite',
                          onPressed: () {
                            // To be implemented
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // NEW badge if applicable
        if (isNew)
          const Positioned(
            top: 0,
            right: 0,
            child: NewBadge(),
          ),
      ],
    );
  }
  
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return Opacity(
      opacity: onPressed != null ? 1.0 : 0.5,
      child: TextButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
  
  Color _getColorForType(LocationType type) {
    switch (type) {
      case LocationType.restaurant:
        return Colors.redAccent;
      case LocationType.hotel:
        return Colors.blueAccent;
      case LocationType.attraction:
        return Colors.greenAccent;
      case LocationType.landmark:
        return Colors.purpleAccent;
      case LocationType.other:
        return Colors.orangeAccent;
    }
  }
  
  IconData _getIconForType(LocationType type) {
    switch (type) {
      case LocationType.restaurant:
        return Icons.restaurant;
      case LocationType.hotel:
        return Icons.hotel;
      case LocationType.attraction:
        return Icons.attractions;
      case LocationType.landmark:
        return Icons.location_city;
      case LocationType.other:
        return Icons.place;
    }
  }
  
  List<Color> _getGradientForType(LocationType type) {
    final baseColor = _getColorForType(type);
    return [
      baseColor,
      baseColor.withBlue((baseColor.blue + 50) % 255),
    ];
  }
}
```

## Update the Map Page to Use New Widgets

Finally, let's update your map page to use these enhanced widgets:

```dart
// Modify your map_page.dart to use the enhanced location details
// (Showing only the relevant part that needs changing)
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
          
          return Column(
            children: [
              // Main content area
              Expanded(
                child: Row(
                  children: [
                    // Map view
                    Expanded(
                      flex: 3, // Takes more space
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
                    
                    // Location details when selected
                    if (state.selectedLocation != null)
                      Expanded(
                        flex: 2, // Takes less space than map
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Theme.of(context).dividerColor,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              // Close button
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    _mapBloc.add(const ClearSelection());
                                  },
                                ),
                              ),
                              
                              // Location details content
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.all(16.0),
                                  child: LocationDetailsContent(
                                    location: state.selectedLocation!,
                                    isNew: true, // Just for demonstration
                                    onAddToTrip: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Adding to trip will be implemented in a later step')),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Bottom locations list
              Container(
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
            ],
          );
        },
      ),
    ),
  );
}
```

These implementations showcase all four custom widget techniques:
1. CustomPainter with the CircularRatingIndicator
2. Advanced BoxDecoration with FancyCard
3. RotatedBox with VerticalLabel and NewBadge
4. Opacity effects with GlassContainer

Together, they create a much more visually appealing and engaging UI for your travel explorer app, while demonstrating advanced Flutter UI techniques.