# step-5-setup

Let's look at your existing code to identify a good candidate for extracting into a Flutter package. Creating a package is an excellent way to teach modularization, reusability, and proper API design.

## Identifying Package Candidates

Based on the code we've created so far, here are some potential candidates for extraction to a package:

1. **Animation Utilities**
   - The animation components we just created (FadeSlideTransition, PulsingWidget, etc.)
   - These are generic enough to be reused across projects

2. **Map Components**
   - Custom map markers, location cards, or map interaction utilities
   - Useful for any app that needs map functionality

3. **Custom UI Components**
   - The FancyCard, GlassContainer, or other UI elements
   - Could become a design system package

4. **Location Data Models and Repository**
   - The location model and repository pattern
   - Could be a data layer package

## Best Package Candidate: Location Rating System

I suggest creating a **`travel_rating`** package that includes:

1. The `CircularRatingIndicator` we developed
2. A star rating input widget
3. Rating data models
4. Rating calculation utilities

This makes a good package because:
- It's focused on a specific function
- It's reusable across many apps
- It has clear boundaries
- It's simple enough to implement in a workshop setting
- It shows proper separation of concerns

## Workshop Implementation

Here's how we could approach this:

### 1. Create the Package Structure

```bash
# Create a packages directory in your project
mkdir -p packages/travel_rating

# Initialize a Flutter package
cd packages/travel_rating
flutter create --template=package .
```

### 2. Define the Package API

Let's design our package's public API:

```dart
// lib/travel_rating.dart
library travel_rating;

export 'src/circular_rating_indicator.dart';
export 'src/star_rating_input.dart';
export 'src/rating_model.dart';
export 'src/rating_utils.dart';
```

### 3. Implement Core Components

#### Rating Model

```dart
// lib/src/rating_model.dart
class RatingModel {
  final double value;
  final int totalRatings;
  final DateTime lastUpdated;
  final List<RatingCriteria>? criteria;

  RatingModel({
    required this.value,
    this.totalRatings = 0,
    DateTime? lastUpdated,
    this.criteria,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  factory RatingModel.empty() {
    return RatingModel(value: 0.0);
  }

  RatingModel copyWith({
    double? value,
    int? totalRatings,
    DateTime? lastUpdated,
    List<RatingCriteria>? criteria,
  }) {
    return RatingModel(
      value: value ?? this.value,
      totalRatings: totalRatings ?? this.totalRatings,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      criteria: criteria ?? this.criteria,
    );
  }
}

class RatingCriteria {
  final String name;
  final double value;
  final double weight;

  const RatingCriteria({
    required this.name,
    required this.value,
    this.weight = 1.0,
  });
}
```

#### Circular Rating Indicator

```dart
// lib/src/circular_rating_indicator.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'rating_model.dart';

class CircularRatingIndicator extends StatelessWidget {
  final double rating;
  final double size;
  final Color backgroundColor;
  final Color foregroundColor;
  final double strokeWidth;
  final Widget? child;
  final RatingModel? ratingModel;

  const CircularRatingIndicator({
    super.key,
    required this.rating,
    this.size = 60.0,
    this.backgroundColor = Colors.grey,
    this.foregroundColor = Colors.amber,
    this.strokeWidth = 8.0,
    this.child,
    this.ratingModel,
  });

  /// Create from a rating model
  factory CircularRatingIndicator.fromModel({
    required RatingModel model,
    double size = 60.0,
    Color backgroundColor = Colors.grey,
    Color foregroundColor = Colors.amber,
    double strokeWidth = 8.0,
    Widget? child,
  }) {
    return CircularRatingIndicator(
      rating: model.value,
      size: size,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      strokeWidth: strokeWidth,
      child: child,
      ratingModel: model,
    );
  }

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
            painter: _CircularRatingPainter(
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

class _CircularRatingPainter extends CustomPainter {
  final double rating;
  final double maxRating;
  final Color backgroundColor;
  final Color foregroundColor;
  final double strokeWidth;

  _CircularRatingPainter({
    required this.rating,
    this.maxRating = 5.0,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.strokeWidth,
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
      -pi / 2, // Start from top
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
```

#### Star Rating Input

```dart
// lib/src/star_rating_input.dart
import 'package:flutter/material.dart';
import 'rating_model.dart';

class StarRatingInput extends StatefulWidget {
  final double initialRating;
  final ValueChanged<double> onRatingChanged;
  final int starCount;
  final Color activeColor;
  final Color inactiveColor;
  final double size;
  final bool allowHalfRating;
  final IconData filledIcon;
  final IconData halfFilledIcon;
  final IconData emptyIcon;

  const StarRatingInput({
    super.key,
    this.initialRating = 0.0,
    required this.onRatingChanged,
    this.starCount = 5,
    this.activeColor = Colors.amber,
    this.inactiveColor = Colors.grey,
    this.size = 24.0,
    this.allowHalfRating = true,
    this.filledIcon = Icons.star,
    this.halfFilledIcon = Icons.star_half,
    this.emptyIcon = Icons.star_border,
  });

  factory StarRatingInput.fromModel({
    required RatingModel model,
    required ValueChanged<double> onRatingChanged,
    int starCount = 5,
    Color activeColor = Colors.amber,
    Color inactiveColor = Colors.grey,
    double size = 24.0,
    bool allowHalfRating = true,
  }) {
    return StarRatingInput(
      initialRating: model.value,
      onRatingChanged: onRatingChanged,
      starCount: starCount,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      size: size,
      allowHalfRating: allowHalfRating,
    );
  }

  @override
  State<StarRatingInput> createState() => _StarRatingInputState();
}

class _StarRatingInputState extends State<StarRatingInput> {
  late double _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.starCount, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _rating = index + 1.0;
              widget.onRatingChanged(_rating);
            });
          },
          onHorizontalDragUpdate: widget.allowHalfRating
              ? (details) {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  final localPosition = box.globalToLocal(details.globalPosition);
                  final starWidth = box.size.width / widget.starCount;
                  final starIndex = localPosition.dx ~/ starWidth;
                  
                  if (starIndex < 0) {
                    _updateRating(0);
                  } else if (starIndex >= widget.starCount) {
                    _updateRating(widget.starCount.toDouble());
                  } else {
                    final starCenterX = starWidth * (starIndex + 0.5);
                    final position = localPosition.dx - starWidth * starIndex;
                    final halfStar = position < (starWidth / 2);
                    _updateRating(
                      starIndex + (halfStar ? 0.5 : 1.0),
                    );
                  }
                }
              : null,
          child: Icon(
            _getIconData(index + 1),
            color: _getColor(index + 1),
            size: widget.size,
          ),
        );
      }),
    );
  }

  void _updateRating(double rating) {
    setState(() {
      _rating = rating;
      widget.onRatingChanged(_rating);
    });
  }

  IconData _getIconData(int index) {
    if (index <= _rating.floor()) {
      return widget.filledIcon;
    } else if (index - 0.5 == _rating) {
      return widget.halfFilledIcon;
    } else {
      return widget.emptyIcon;
    }
  }

  Color _getColor(int index) {
    if (index <= _rating) {
      return widget.activeColor;
    } else if (index - 0.5 == _rating) {
      return widget.activeColor;
    } else {
      return widget.inactiveColor;
    }
  }
}
```

#### Rating Utilities

```dart
// lib/src/rating_utils.dart
import 'rating_model.dart';

class RatingUtils {
  /// Calculate weighted average of multiple ratings
  static double calculateWeightedRating(List<RatingCriteria> criteria) {
    if (criteria.isEmpty) return 0.0;
    
    double totalWeight = 0.0;
    double weightedSum = 0.0;
    
    for (final criterion in criteria) {
      totalWeight += criterion.weight;
      weightedSum += criterion.value * criterion.weight;
    }
    
    return totalWeight > 0 ? weightedSum / totalWeight : 0.0;
  }
  
  /// Combine a new rating with existing rating model
  static RatingModel addRating(RatingModel current, double newRating) {
    final totalRatings = current.totalRatings + 1;
    final totalValue = current.value * current.totalRatings + newRating;
    final newValue = totalValue / totalRatings;
    
    return current.copyWith(
      value: newValue,
      totalRatings: totalRatings,
      lastUpdated: DateTime.now(),
    );
  }
  
  /// Get descriptive text for rating value
  static String getRatingDescription(double rating) {
    if (rating >= 4.5) return 'Excellent';
    if (rating >= 4.0) return 'Very Good';
    if (rating >= 3.0) return 'Good';
    if (rating >= 2.0) return 'Fair';
    return 'Poor';
  }
  
  /// Format rating for display
  static String formatRating(double rating, {int decimalPlaces = 1}) {
    return rating.toStringAsFixed(decimalPlaces);
  }
}
```

### 4. Configure the Package

Update the `pubspec.yaml` for your package:

```yaml
name: travel_rating
description: A Flutter package for travel-related rating components and utilities
version: 0.0.1
homepage: https://bwnyasse.net

environment:
  sdk: ">=3.0.0 <4.0.0"
  flutter: ">=3.10.0"
  
dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0

# No assets or fonts needed for this package
```

### 5. Set Up Local Development

To use your package locally in the main app, add a dependency in your main app's `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  # Local package reference
  travel_rating:
    path: ./../packages/travel_rating
```

### 6. Using the Package in Your App

```dart
// Example usage in your location_details_content.dart
import 'package:travel_rating/travel_rating.dart';

// Inside your widget
RatingModel locationRating = RatingModel(
  value: location.rating ?? 0.0,
  totalRatings: 42, // Example value
);

// Using CircularRatingIndicator
CircularRatingIndicator.fromModel(
  model: locationRating,
  size: 80.0,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        RatingUtils.formatRating(locationRating.value),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      Text(
        RatingUtils.getRatingDescription(locationRating.value),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
        ),
      ),
    ],
  ),
),

// Using StarRatingInput
StarRatingInput.fromModel(
  model: locationRating,
  onRatingChanged: (value) {
    // Handle rating change
    print('New rating: $value');
  },
),
```

## Workshop Teaching Points

Here are the key concepts to cover in this package creation workshop:

1. **Package Structure**
   - Library exports and organization
   - Public vs private API design
   - Folder structure best practices

2. **API Design**
   - Creating a clean, intuitive API
   - Factory constructors for flexibility
   - Documentation practices

3. **Dependency Management**
   - Managing package dependencies
   - Local development with path references
   - Version constraints

4. **Testing and Documentation**
   - Writing package-level tests
   - Creating example applications
   - Documenting the API

5. **Publishing (Optional)**
   - Preparing for pub.dev publication
   - Versioning strategies
   - License considerations

During the workshop, you can guide students through:
1. Extracting existing code into the package structure
2. Designing a clean API
3. Using the package in the main app
4. Adding new features to the package

This approach gives students a practical understanding of package development while enhancing your Travel Explorer app with a reusable rating system.