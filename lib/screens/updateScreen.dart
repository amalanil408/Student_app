import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_2/db/functions/db_functions.dart';
import 'package:project_2/db/models/db_models.dart';

class StudentDataUpdate extends StatefulWidget {
  final StudentModel student;
  const StudentDataUpdate({Key? key, required this.student}) : super(key: key);

  @override
  _StudentDataUpdateState createState() => _StudentDataUpdateState();
}

class _StudentDataUpdateState extends State<StudentDataUpdate> {
  final TextEditingController inputName = TextEditingController();
  final TextEditingController inputAge = TextEditingController();
  final TextEditingController inputGuardian = TextEditingController();
  final TextEditingController inputPhone = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? _selectedImage;
  Uint8List? _imageBytes;

  @override
  void initState() {
    inputName.text = widget.student.name;
    inputAge.text = widget.student.age;
    inputGuardian.text = widget.student.guardian;
    inputPhone.text = widget.student.phone;
    _imageBytes = widget.student.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (ctx) => Container(
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              selectImageFromGallery();
                            },
                            icon: const Icon(Icons.image),
                            iconSize: 60,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : _imageBytes != null
                          ? MemoryImage(_imageBytes!)
                          : null,
                  child: _selectedImage == null && _imageBytes == null
                      ? const Icon(Icons.person)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: inputName,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      labelText: 'Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: inputAge,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      labelText: 'Age',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Age is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: inputGuardian,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      labelText: 'Guardian Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Guardian name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: inputPhone,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      labelText: 'Phone',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      updateDataToDBBtn();
                      Navigator.pop(context);
                    },
                    child: const Text('Update'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> selectImageFromGallery() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
    Navigator.pop(context);
  }

  Future<void> updateDataToDBBtn() async {
    final name = inputName.text.trim();
    final age = inputAge.text.trim();
    final guardian = inputGuardian.text.trim();
    final phone = inputPhone.text.trim();

    if (phone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid Mobile Number')),
      );
      return;
    }

    try {
      if (_selectedImage != null) {
        _imageBytes = await _selectedImage!.readAsBytes();
      }

      final updatedStudent = StudentModel(
        id: widget.student.id,
        name: name,
        age: age,
        guardian: guardian,
        phone: phone,
        image: _imageBytes,
      );

      await updateStudentDataFromDb(name, age, guardian, phone, _imageBytes!, widget.student.id!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to update student: $e')),
      );
    }
  }
}
