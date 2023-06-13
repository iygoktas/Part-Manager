import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parcacii/for_list_page/listing_class.dart';
import 'package:parcacii/numberPage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'ogrenci_database_helper/ogrenci.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class ForSelectMaterial extends StatefulWidget {
  final int? studentId;
  final Ogrenci student;
  const ForSelectMaterial({
    Key? key,
    required this.studentId,
    required this.student,
  }) : super(key: key);

  @override
  _ForSelectMaterialState createState() => _ForSelectMaterialState();
}

class _ForSelectMaterialState extends State<ForSelectMaterial> {
  int? selectedItem;
  Future<List<Map<String, dynamic>>>? _futureData;

  Future<List<Map<String, dynamic>>> getTableData() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'parcaci.db');

    final database = await openDatabase(path);

    final List<Map<String, dynamic>> tableData =
        await database.query('material');

    await database.close();

    return tableData;
  }

  Future<Database> createDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'parcaci.db');

    final exists = await databaseExists(path);
    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      final database = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE  material(
            id INTEGER PRIMARY KEY,
            name TEXT
          )
        ''');
      });

      // Insert data into the 'material' table when creating the database for the first time
      await insertData(database);

      return database;
    } else {
      final database = await openDatabase(path);
      return database;
    }
  }

  Future<void> insertData(Database database) async {
    List<Map<String, dynamic>> data = [
      {'name': 'Arduino'},
      {'name': 'Breadboard'},
      {'name': 'LED'},
      {'name': '220 Ohm Resistor'},
      {'name': 'Connection Cables'},
      {'name': 'Switch'},
      {'name': '10K Ohm Resistor'},
      {'name': 'Potentiometer'},
      {'name': 'Voltmeter'},
      {'name': 'LDR'},
      {'name': 'Common Cathode LED'},
      {'name': 'Resistor'},
      {'name': 'Active Buzzer'},
      {'name': 'Button'},
      {'name': 'Common Cathode Display'},
      {'name': 'IR Receiver'},
      {'name': 'IR Transmitter Remote Control'},
      {'name': 'Ultrasonic Distance Sensor'},
      {'name': 'LCD Display'},
      {'name': 'Temperature Sensor'},
    ];
    for (var item in data) {
      await database.insert('material', item);
    }
  }

  @override
  void initState() {
    super.initState();
    _futureData = createDatabase().then((database) => getTableData());
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      appBar: AppBar(
        title: Text("materialSelect".tr),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('error:'.tr + " " + "${snapshot.error}"));
          } else {
            final dataList = snapshot.data;
            return ListView.builder(
              itemCount: dataList!.length,
              itemBuilder: (context, index) {
                final item = dataList[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedItem = item['id'];
                    });
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NumberPage(
                          date: item['date'],
                          ilkDeger: Listing(),
                          student: widget.student,
                          materialId: item['id'],
                          materialName: item['name'],
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    trailing: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Center(
                                    child: Text(item['name'].toString().tr)),
                                content: SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: Image.asset(
                                      'assets/images/${item['name'].toString()}.png'),
                                ),
                              );
                            },
                          );
                        },
                        child: const Icon(Icons.info_outline),
                      ),
                    ),
                    title: Text(item['name'].toString().tr),
                    leading: const Text("●"),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
