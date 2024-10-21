import 'entry_exit_record.dart';

class Person {
  final String name;
  final String role;  // 예: 학생, 교수 등
  final EntryExitRecord record;

  Person({required this.name, required this.role, required this.record});
}
