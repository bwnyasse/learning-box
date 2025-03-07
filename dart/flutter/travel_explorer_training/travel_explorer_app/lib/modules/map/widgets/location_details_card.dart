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