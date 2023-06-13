import 'dart:io';
import 'package:flutter/material.dart';
import 'package:parcacii/home_page.dart';
import 'package:parcacii/local_string.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'for_list_page/listing_database_helper.dart';
import 'package:get/get.dart';

void main() {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    WidgetsFlutterBinding.ensureInitialized();
    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      final listingDbHelper = ListingDatabaseHelper();
      await listingDbHelper.initializeDatabase();
      Get.put(LocalString());
      runApp(const MyApp());
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
