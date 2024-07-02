import 'package:flutter/material.dart';
import 'package:project_2/db/functions/db_functions.dart';
import 'package:project_2/db/models/db_models.dart';
import 'package:project_2/screens/add_screen.dart';
import 'package:project_2/screens/studentProfileScreen.dart';
import 'package:project_2/screens/updateScreen.dart';

class screenHome extends StatefulWidget {
  const screenHome({super.key});

  @override
  State<screenHome> createState() => _screenHomeState();
}

class _screenHomeState extends State<screenHome> {

  bool isGrid = false;
  TextEditingController _searchController = TextEditingController();
  List<StudentModel> _filteredStudent = [];

  @override
  void initState() {
    _searchController.addListener(_filteredStudents);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.removeListener(_filteredStudents);
    _searchController.dispose();
    super.dispose();
  }

  void _filteredStudents() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStudent = studentListNotifier.value.where
      ((student)=>(student.name.toLowerCase())
      .contains(query))
      .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    getStudentDetailsFromDb();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Center(child: Text('Student_app',style: TextStyle(color: Colors.white),),),
        actions: [
          IconButton(
            onPressed: (){
              setState(() {
                isGrid = !isGrid;
              });
            }, 
            icon: Icon(isGrid? Icons.list : Icons.grid_view)
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> screenAddStudent()));
        }
        ,child: const Icon(Icons.add),
        ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                hintText: 'Search',
                suffixIcon: const Icon(Icons.search)
              ),
            ),
            const SizedBox(height: 10,),
            Expanded(
              child: ValueListenableBuilder<List<StudentModel>>(
                valueListenable: studentListNotifier,
                builder: (context, studnet, child) {
                  if(_searchController.text.isEmpty){
                    _filteredStudent = studnet;
                  }
                  if(_filteredStudent.isEmpty){
                    return Center(child: Text('No Student Added'),);
                  }
                  return isGrid ? buildGridView(_filteredStudent) : buildListView(_filteredStudent);
                },
              )
              )
          ],
        ),
      ),
    );
  }
}

 Widget buildGridView(List<StudentModel> students) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 1,
      ),
      itemCount: students.length,
      padding: const EdgeInsets.all(15),
      itemBuilder: (context, index) {
        final student = students[index];

        return Container(
          decoration: BoxDecoration(
              color: Colors.teal[200],
              borderRadius: BorderRadius.circular(20)),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => studentProfile(student: student)));
            },
            child: GridTile(
              header: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: student.image != null
                        ? MemoryImage(student.image!)
                        : null,
                    child:
                        student.image == null ? const Icon(Icons.person) : null,
                  ),
                  Text(
                    student.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(context: context, builder: (ctx){
                          return StudentDataUpdate(student: student);
                        });
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text(
                                'Are you sure you want to delete this student?'),
                            actions: [
                              TextButton(
                                child: const Text('No'),
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Yes'),
                                onPressed: () async {
                                  await deleteStudentDataFromDb(student.id!);
                                  Navigator.of(ctx).pop();
                                },
                              ),
                            ],
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
          ),
        );
      },
    );
  }

Widget buildListView(List<StudentModel> students) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final student = students[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 7),
          decoration: BoxDecoration(
              color: Colors.teal[200],
              borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.symmetric(vertical: 20),
          height: 100,
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => studentProfile(student: student)));
            },
            title: Text(
              student.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            leading: CircleAvatar(
              radius: 30,
              backgroundImage:
                  student.image != null ? MemoryImage(student.image!) : null,
              child: student.image == null ? const Icon(Icons.person) : null,
            ),
            // subtitle: Text('Age: ${student.age}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    showDialog(context: context, builder: (ctx){
                          return StudentDataUpdate(student: student);
                        });
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Confirm Delete'),
                        content: const Text(
                            'Are you sure you want to delete this student?'),
                        actions: [
                          TextButton(
                            child: const Text('No'),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Yes'),
                            onPressed: () async {
                              await deleteStudentDataFromDb(student.id!);
                              Navigator.of(ctx).pop();
                            },
                          ),
                        ],
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
        );
      },
      separatorBuilder: (context, index) => const Divider(
        height: 5,
        color: Colors.white,
      ),
      itemCount: students.length,
    );
  }
