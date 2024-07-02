import 'package:flutter/foundation.dart';

class StudentModel{
  int? id;
  final String name;
  final String age;
  final String guardian;
  final String phone;
  Uint8List? image;

  StudentModel({
    this.id,
    required this.name, 
    required this.age, 
    required this.guardian, 
    required this.phone,
    this.image
    });

    static StudentModel fromMap(Map<String , Object?> map){
      final id = map['id'] as int;
      final name = map['name'] as String;
      final age = map['age'] as String;
      final guardian = map['guardian'] as String;
      final phone = map['phone'] as String;
      final image = map['image'] as Uint8List;

      return StudentModel(
        id: id,
        name: name, 
        age: age, 
        guardian: guardian, 
        phone: phone,
        image: image
        );
    }
}