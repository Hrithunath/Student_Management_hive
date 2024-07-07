import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:student_management_provider/model/db_model.dart';

ValueNotifier<List<Student>> studentListNotifier = ValueNotifier([]);
Future<void> addStudent(Student data) async {
  final box = await Hive.openBox<Student>("students");
  box.add(data);
  await getStudents();
}

Future<void> getStudents() async {
  final box = await Hive.openBox<Student>('students');
  studentListNotifier.value = box.values.toList();
  studentListNotifier.notifyListeners();
}


 
void updateStudent(Student data, int id) async {
  final box = await Hive.openBox<Student>('students');
  try {
    await box.put(id, data);
    List<Student> students = box.values.toList();
    studentListNotifier.notifyListeners();
  } finally {
    await box.close();
  }
}

Future<void> deleteStudent(int index) async {
  final box = await Hive.openBox<Student>("students");
  await box.deleteAt(index);
  await getStudents();
}
