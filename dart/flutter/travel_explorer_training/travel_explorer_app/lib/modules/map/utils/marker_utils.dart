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