import 'package:flutter/material.dart';
import 'package:project_2/db/models/db_models.dart';

class studentProfile extends StatelessWidget {
  final StudentModel student;
  const studentProfile({super.key, required this.student});



  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 20
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 80,
            backgroundImage: student.image != null ? MemoryImage(student.image!) : null,
            child: student.image == null ? const Icon(Icons.person) : null
          ),
          const SizedBox(height: 80,),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              width: 350,
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Name : ${student.name}',style: textStyle,),
                  const SizedBox(height: 20,),
                   Text('Age : ${student.age}',style: textStyle,),
                  const SizedBox(height: 20,),
                   Text('Guardian Name : ${student.guardian}',style: textStyle,),
                  const SizedBox(height: 20,),
                   Text('Phone : ${student.phone}',style: textStyle,),
                  const SizedBox(height: 20,),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}