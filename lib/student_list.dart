import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parcacii/forSelectMaterial.dart';
import 'package:parcacii/ogrenci_database_helper/ogrenci.dart';
import 'package:parcacii/ogrenci_database_helper/ogrenci_database_helper.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  List<Ogrenci>? students;
  List<Ogrenci>? filteredStudents;
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  IconData searchIcon = Icons.search;
  IconData clearIcon = Icons.clear;

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    final studentList = await UserDatabaseHelper.getUsers();
    setState(() {
      students = studentList;
      filteredStudents = studentList;
    });
  }

  void filterStudents(String query) {
    List<Ogrenci> filteredList = [];
    if (query.isNotEmpty) {
      filteredList = students!
          .where((student) =>
              student.ad!.toLowerCase().contains(query.toLowerCase()) ||
              student.soyad!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      filteredList = students!;
    }

    filteredList.sort((a, b) {
      if (a.ad!.toLowerCase().startsWith(query.toLowerCase())) {
        return -1;
      } else if (b.ad!.toLowerCase().startsWith(query.toLowerCase())) {
        return 1;
      }
      return a.soyad!.compareTo(b.soyad!);
    });

    setState(() {
      filteredStudents = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: isSearching
            ? TextField(
                controller: searchController,
                onChanged: (value) {
                  filterStudents(value);
                },
                decoration: InputDecoration(
                  hintText: "searchBar".tr,
                  
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              )
            : Text("studentList".tr),
        actions: [
          IconButton(
            icon: Icon(isSearching ? clearIcon : searchIcon),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  if (searchController.text.isNotEmpty) {
                    searchController.clear();
                    filterStudents('');
                  }
                  isSearching = false;
                } else {
                  isSearching = true;
                }
              });
            },
          ),
        ],
      ),
      body: buildStudentList(),
    );
  }

  Widget buildStudentList() {
    if (filteredStudents == null) {
      return Center(child: CircularProgressIndicator());
    }

    if (filteredStudents!.isEmpty) {
      return Center(child: Text('noStudentError'.tr));
    }

    return ListView.builder(
      itemCount: filteredStudents!.length,
      itemBuilder: (context, index) {
        final student = filteredStudents![index];
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            height: 90,
            child: Card(
              elevation: 15,
              color: const Color.fromARGB(0, 35, 35, 35),
              shadowColor: const Color.fromARGB(0, 0, 0, 0),
              shape: const RoundedRectangleBorder(
                side: BorderSide(
                  color: Color.fromARGB(255, 233, 233, 233),
                  width: 1.2,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: ((context) {
                          return AlertDialog(
                            actions: [
                              TextButton(
                                onPressed: (() async {
                                  var res = await UserDatabaseHelper.deleteUser(
                                      student.id!);
                                  if (res > 0) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        duration: const Duration(seconds: 2),
                                        content: Text('deletedMessage'.tr),
                                      ),
                                    );
                                    fetchStudents();
                                    Navigator.of(context).pop();
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text('errorMessage'.tr),
                                      ),
                                    );
                                  }
                                }),
                                child: Text("yes".tr),
                              ),
                              TextButton(
                                onPressed: (() {
                                  Navigator.of(context).pop();
                                }),
                                child: Text("no".tr),
                              ),
                            ],
                            title: Text("deleteQuestion".tr),
                            content: Text(
                              'deleteDescriptionQuestion'.tr +
                                  " " +
                                  '${student.ad} ${student.soyad}',
                            ),
                          );
                        }),
                      );
                    },
                    child: ListTile(
                      leading: const Icon(
                        Icons.person,
                        size: 30,
                      ),
                      title: Center(
                        child: Text(
                          "${student.ad!} ${student.soyad!}",
                        ),
                      ),
                      subtitle: Center(
                        child: Text(
                          "${student.sinif!}/${student.sube!} | ${student.numara}",
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ForSelectMaterial(
                                student: student,
                                studentId: student.id!,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
