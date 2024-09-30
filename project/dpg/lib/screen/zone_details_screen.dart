import 'package:flutter/material.dart';

class ZoneDetailsScreen extends StatelessWidget {
  final String zoneName;
  final int currentOccupancy;

  ZoneDetailsScreen({required this.zoneName, required this.currentOccupancy});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$zoneName Details'),
        backgroundColor: Color(0xFFE43022),  // #E43022
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Occupancy: $currentOccupancy',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Entry/Exit Logs', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: 10,  // 임시로 10개의 로그를 표시
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Log $index - Entry Time: 12:30 PM'),
                    leading: Icon(Icons.access_time),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
