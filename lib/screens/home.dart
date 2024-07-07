import 'dart:io';
import 'package:flutter/material.dart';
import 'package:student_management_provider/common/widget/custom_Alert_dialog.dart';
import 'package:student_management_provider/model/db_model.dart';
import 'package:student_management_provider/provider/home_Controller.dart';
import 'package:student_management_provider/screens/add_students.dart';
import 'package:student_management_provider/screens/edit_students.dart';
import 'package:student_management_provider/screens/search.dart';
import 'package:student_management_provider/screens/view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  initState() {
    super.initState();
    getStudents();
  }

  @override
  Widget build(BuildContext context) {
    getStudents();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          const SizedBox(width: 10),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchStudent()));
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: ValueListenableBuilder<List<Student>>(
        valueListenable: studentListNotifier,
        builder: (context, studentList, child) {
          if (studentList.isEmpty) {
            return const Center(child: Text('No Data Found'));
          }
          return ListView.builder(
            itemCount: studentList.length,
            itemBuilder: (context, index) {
              final student = studentList[index];
              return Card(
                color: Colors.grey[200],
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profile(student: student),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: student.image.isNotEmpty &&
                              File(student.image).existsSync()
                          ? FileImage(File(student.image))
                          : null,
                      child: student.image.isEmpty
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text(student.name),
                    subtitle: Text(student.classs),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                (MaterialPageRoute(
                                    builder: (context) =>
                                        EditStudents(student: student))));
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => DeleteAlert(
                                onDelete: () {
                                  deleteStudent(index);
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddStudents()),
          );
        },
        backgroundColor: Colors.yellow,
        child: const Icon(Icons.add),
      ),
    );
  }
}
