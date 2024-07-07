import 'dart:io';
import 'package:flutter/material.dart';
import 'package:student_management_provider/model/db_model.dart';
import 'package:student_management_provider/provider/home_Controller.dart';
import 'package:student_management_provider/screens/view.dart';

class SearchStudent extends StatefulWidget {
  const SearchStudent({super.key});

  @override
  _SearchStudentState createState() => _SearchStudentState();
}

class _SearchStudentState extends State<SearchStudent> {
  final searchController = TextEditingController();
  List<Student> searchResults = [];

  void _searchStudents(String query) {
    final students = studentListNotifier.value;
    if (query.isNotEmpty) {
      searchResults = students.where((student) {
        return student.name.toLowerCase().contains(query.toLowerCase()) ||
               student.classs.toLowerCase().contains(query.toLowerCase()) ||
               student.admissionNumber.toLowerCase().contains(query.toLowerCase()) ||
               student.address.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } else {
      searchResults = [];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search Students'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onChanged: (query) => _searchStudents(query),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final student = searchResults[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: student.image.isNotEmpty && File(student.image).existsSync()
                          ? FileImage(File(student.image))
                          : null,
                        child: student.image.isEmpty
                          ? const Icon(Icons.person)
                          : null,
                      ),
                      title: Text(student.name),
                      subtitle: Text(student.classs),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Profile(student: student),
                          ),
                        );
                      },
                    ),
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
