import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:project_2/db/models/db_models.dart';
import 'package:sqflite/sqflite.dart';

ValueNotifier<List<StudentModel>> studentListNotifier = ValueNotifier([]);

late Database _db;

//DB initilazation
Future<void> initzlizeDB() async {
   _db = await openDatabase(
    'student_db',
    version: 1,
    onCreate: (db, version) {
      db.execute('CREATE TABLE student (id INTEGER PRIMARY KEY , name TEXT , age TEXT , guardian TEXT , phone TEXT , image BLOB)');
    },
    );
}

//Add Function
Future<void> addStudentDataToDb(StudentModel value) async {
  _db.rawInsert('INSERT INTO student(name , age , guardian ,phone , image) VALUES (?,?,?,?,?)',
  [
    value.name,
    value.age,
    value.guardian,
    value.phone,
    value.image
    ]);
    await getStudentDetailsFromDb();
}

//Display FUnction
Future<void> getStudentDetailsFromDb() async {
  final _values= await _db.rawQuery('SELECT * FROM student');
  final _student = _values.map((map) => StudentModel.fromMap(map)).toList();
  studentListNotifier.value = _student;
  studentListNotifier.notifyListeners();
}

//Delete Function
Future<void> deleteStudentDataFromDb(int id) async {
  _db.rawDelete('DELETE FROM student WHERE id = ?',[id]);
  await getStudentDetailsFromDb();
  studentListNotifier.notifyListeners();
}

//Update Function
Future<void> updateStudentDataFromDb(String name , String age , String guardian , String phone , Uint8List image , int id) async{
  _db.rawUpdate('UPDATE student SET name = ? , age = ? , guardian = ? , phone = ? , image = ? WHERE id = ?',
  [name,
  age,
  guardian,
  phone,
  image,
  id
  ]);
  await getStudentDetailsFromDb();
}