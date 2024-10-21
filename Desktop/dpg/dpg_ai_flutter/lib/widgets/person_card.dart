import 'package:flutter/material.dart';
import '../models/person_model.dart';

class PersonCard extends StatelessWidget {
  final Person person;
  final VoidCallback onTap;

  PersonCard({required this.person, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.person),
        title: Text(person.name),
        subtitle: Text(person.role),
        onTap: onTap,
      ),
    );
  }
}
