import 'package:flutter/material.dart';
import '../screens/person_details_screen.dart';

class OccupantDialog extends StatelessWidget {
  final String floorName;
  final List<Map<String, String?>> occupants;

  const OccupantDialog(
      {super.key, required this.floorName, required this.occupants});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: Color(0xFFEAEAEC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 2.0, bottom: 10.0),
            child: Text(
              '$floorName 인원 목록',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'manru',
              ),
            ),
          ),
          Expanded(
            child: occupants.isNotEmpty
                ? GridView.builder(
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1 / 1.4,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: occupants.length,
              itemBuilder: (context, index) {
                final occupant = occupants[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonDetailsScreen(
                          studentName: occupant['name']!,
                          studentRole: occupant['role']!,
                          phoneNumber: occupant['phone']!,
                          userId: int.parse(occupant['user_id']!),
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 70.0,
                            height: 70.0,
                            margin: const EdgeInsets.only(bottom: 8.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F0F7),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 50.0,
                              color: Color(0xFF4B4F87),
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            occupant['name'] ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'manru',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            occupant['role'] ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'manru',
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
                : Center(
              child: Text(
                '인원이 없습니다.',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'manru',
                  color: Colors.grey.withOpacity(0.9),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}