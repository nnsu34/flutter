import 'package:flutter/material.dart';

class BuildingCard extends StatelessWidget {
  final String buildingName;
  final VoidCallback onTap;

  BuildingCard({required this.buildingName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.white,
      child: ListTile(
        title: Text(buildingName),
        onTap: onTap,
      ),
    );
  }
}
