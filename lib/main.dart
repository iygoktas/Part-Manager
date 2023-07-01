import 'dart:io';
import 'package:flutter/material.dart';
import 'package:parcacii/add_student.dart';
import 'package:parcacii/assignedPage.dart';
import 'package:parcacii/broken_normal_page.dart';
import 'package:parcacii/forSelectMaterial.dart';
import 'package:parcacii/home_page.dart';
import 'package:parcacii/local_string.dart';
import 'package:parcacii/numberPage.dart';
import 'package:parcacii/retrieved_assigments/retrieved_assignment.dart';
import 'package:parcacii/student_list.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'for_list_page/listing_database_helper.dart';
import 'package:get/get.dart';
import 'ogrenci_database_helper/ogrenci.dart';
import 'ogrenci_database_helper/ogrenci_database_helper.dart';

void main() async {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsFlutterBinding.ensureInitialized();
    final listingDbHelper = ListingDatabaseHelper();
    await listingDbHelper.initializeDatabase();
    Get.put(LocalString());
    runApp(const MyApp());
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key,});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final int? studentId = 0;
  final Ogrenci student = Ogrenci(ad: "", soyad: "", sinif: "", sube: "", numara: "");
  final studentList = UserDatabaseHelper.getUsers();
  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      
        routes: {
          '/addStudent': (context) => const AddStudent(),
          '/studentList': (context) => const StudentList(),
          '/assignPage': (context) => const AssignedPage(),
          '/retrievedPage': (context) => const RetrievedAssignmentsPage(),
          '/materialSelect': (context) => ForSelectMaterial(
              studentId: student.id, student: student)
        },
        translations: LocalString(),
        locale: const Locale('en', 'US'),
        debugShowCheckedModeBanner: false,
        title: 'Part Manager',
        theme: ThemeData(
          useMaterial3: false,
          primarySwatch: Colors.orange,
        ),
        home: HomePage());
  }
}
