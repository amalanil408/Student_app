import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_2/db/functions/db_functions.dart';
import 'package:project_2/db/models/db_models.dart';

class screenAddStudent extends StatefulWidget {
  const screenAddStudent({super.key});

  @override
  State<screenAddStudent> createState() => _screenAddStudentState();
}
final inputName = TextEditingController();
final inputAge = TextEditingController();
final inputGuardian = TextEditingController();
final inputPhone = TextEditingController();
final formKey = GlobalKey<FormState>();
Uint8List? _imageBytes;
File? _selectImage;

class _screenAddStudentState extends State<screenAddStudent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Center(child: Text('Student_App')),
      ),
      backgroundColor: Colors.blueGrey,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Adding image 
            const SizedBox(height: 20,),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context, 
                  builder: (ctx){
                    return Container(
                      width: double.infinity,
                      height: 130,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(onPressed: (){
                            selectImageFromGallery();
                          }, icon: const Icon(Icons.image),iconSize: 60,),
                        ],
                      ),
                    );
                  });
              },
              child: Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 70,
                  child: _selectImage != null ? ClipOval(
                    child: Image.file(_selectImage!,width: 160,height: 160, fit: BoxFit.cover,),): 
                    const Icon(Icons.person,size: 80,),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            // Input Fields
        
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: inputName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      label: const Text('Name',style: TextStyle(color: Colors.white),)
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Name is required';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                     controller: inputAge,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      label: const Text('Age',style: TextStyle(color: Colors.white),)
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Age is required';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                     controller: inputGuardian,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      label: const Text('Guardian Name',style: TextStyle(color: Colors.white),)
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Guardian Name is required';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                     controller: inputPhone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      label: const Text('Phone',style: TextStyle(color: Colors.white),)
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Phone is required';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(onPressed: (){
                        if(formKey!.currentState!.validate()){
                          addStudentBtn();
                          removeImage();
                        }
                      }, child: const Text('Save')),
                      const SizedBox(width: 10,),
                    ],
                  )
                ],
              )
              )
          ],
        ),
      ),
    );
  }

  //Functions
  
  Future<void> selectImageFromGallery() async{
    final _returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _selectImage = File(_returnImage!.path);
    });
    Navigator.pop(context);
  }


  void removeImage() {
    setState(() {
      _selectImage = null; // Clear selected image
      _imageBytes = null; // Clear image bytes
    });
  }

  Future<void> addStudentBtn() async {
    final _name = inputName.text.trim();
    final _age = inputAge.text.trim();
    final _guardian = inputGuardian.text.trim();
    final _phone = inputPhone.text.trim();

   if(_phone.length != 10){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Phone number is invalid')));
   }
   else{
    try{
      if(_selectImage != null){
        _imageBytes = await _selectImage!.readAsBytes();
      }
      final _datas = StudentModel(
        name: _name, 
        age: _age, 
        guardian: _guardian, 
        phone: _phone,
        image: _imageBytes
        );

        await addStudentDataToDb(_datas);
        inputName.clear();
         inputAge.clear();
      inputGuardian.clear();
      inputPhone.clear();
        Navigator.pop(context);
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save student data $e')));
    }
   }
  }

}