import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_management_provider/model/db_model.dart';
import 'package:student_management_provider/provider/home_Controller.dart';

class EditStudents extends StatefulWidget {
  final Student student;

  const EditStudents({Key? key, required this.student}) : super(key: key);

  @override
  _EditStudentsState createState() => _EditStudentsState();
}

class _EditStudentsState extends State<EditStudents> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController classsController;
  late TextEditingController admissionController;
  late TextEditingController addressController;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.student.name);
    classsController = TextEditingController(text: widget.student.classs);
    admissionController =
        TextEditingController(text: widget.student.admissionNumber);
    addressController = TextEditingController(text: widget.student.address);
    selectedImage =
        widget.student.image.isNotEmpty ? File(widget.student.image) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 15),
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: selectedImage != null
                        ? FileImage(selectedImage!)
                        : null,
                    child: selectedImage == null
                        ? const Icon(
                            Icons.person,
                            size: 50,
                          )
                        : null,
                  ),
                  Positioned(
                    left: 60,
                    bottom: -10,
                    child: IconButton(
                      onPressed: () {
                        imagePickGallery();
                      },
                      icon: const Icon(Icons.add_a_photo_outlined),
                      iconSize: 25,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: "Name",
                  hintText: "Enter your full name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name is required";
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: classsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Class",
                  hintText: "Enter your class",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Class is required";
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: admissionController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Admission Number",
                  hintText: "Enter your Admission Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Admission Number is required";
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: addressController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: "Address",
                  hintText: "Enter your full Address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Address is required";
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      
                      nameController.clear();
                      classsController.clear();
                      admissionController.clear();
                      addressController.clear();
                      setState(() {
                        selectedImage = null;
                      });
                    },
                    child: const Text(
                      'Clear',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Save button logic
                      saveButton();
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> imagePickGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Future<void> saveButton() async {
    if (formKey.currentState!.validate()) {
      final updatedStudent = Student(
        name: nameController.text.trim(),
        classs: classsController.text.trim(),
        admissionNumber: admissionController.text.trim(),
        address: addressController.text.trim(),
        image: selectedImage?.path ?? '',
      );

      updateStudent(updatedStudent,widget.student.key);

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    classsController.dispose();
    admissionController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
