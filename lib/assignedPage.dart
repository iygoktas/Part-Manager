import 'package:flutter/material.dart';
import 'for_list_page/listing_database_helper.dart';
import 'retrieved_assigments/retrieved_assignment.dart';
import 'retrieved_assigments/retrieved_assignments_db_helper.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'local_string.dart';
import 'package:flutter/services.dart';

class AssignedPage extends StatefulWidget {
  const AssignedPage({Key? key}) : super(key: key);

  @override
  _AssignedPageState createState() => _AssignedPageState();
}

class _AssignedPageState extends State<AssignedPage> {
  Map<String, dynamic>? _selectedAssignment;
  String? _selectedValue;
  List<Map<String, dynamic>> _assignments = [];
  List<Map<String, dynamic>> _filteredAssignments = [];
  bool _showSearchBar = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  String translateMaterial(String material) {
    return LocalString().keys[Get.locale.toString()]!.containsKey(material)
        ? material.tr
        : material;
  }

  Future<void> loadData() async {
    final dbHelper = ListingDatabaseHelper();
    _assignments = await dbHelper.getAssignments();
    _filteredAssignments = _assignments;
    setState(() {});
  }

  Future<void> deleteAssignment(Map<String, dynamic> assignment) async {
    final dbHelper = ListingDatabaseHelper();
    await dbHelper.deleteAssignment(assignment['id']);
    loadData();
  }

  void filterAssignments(String query) {
    List<Map<String, dynamic>> filteredList = [];
    if (query.isNotEmpty) {
      filteredList = _assignments
          .where((assignment) =>
              assignment['studentName']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              assignment['studentSurname']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    } else {
      filteredList = _assignments;
    }

    setState(() {
      _filteredAssignments = filteredList;
    });
  }

  void toggleSearchBar() {
    setState(() {
      _showSearchBar = !_showSearchBar;
      if (!_showSearchBar) {
        _searchController.clear();
        filterAssignments('');
      }
    });
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    String selectedValue = '';
    void handleRadioValueChanged(String value) {
      setState(() {
        selectedValue = value;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: _showSearchBar
            ? TextField(
                controller: _searchController,
                onChanged: (value) {
                  filterAssignments(value);
                },
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: 'searchBar'.tr,
                  hintStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  border: InputBorder.none,
                ),
              )
            : Text('fourthButton'.tr),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_showSearchBar ? Icons.close : Icons.search),
            onPressed: toggleSearchBar,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _filteredAssignments.length,
              itemBuilder: (context, index) {
                final assignment = _filteredAssignments[index];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAssignment = assignment;
                    });

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Center(child: Text("retrievePart".tr)),
                          content: SizedBox(
                            height: 170,
                            width: 250,
                            child: Column(
                              children: <Widget>[
                                RadioListTile(
                                  title: Text("normal".tr),
                                  value: 'Normal',
                                  groupValue: _selectedValue,
                                  onChanged: (value) {
                                    handleRadioValueChanged(value!);
                                  },
                                ),
                                RadioListTile(
                                  title: Text("broken".tr),
                                  value: 'Broken',
                                  groupValue: _selectedValue,
                                  onChanged: ((value) {
                                    handleRadioValueChanged(value!);
                                  }),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    DateTime currentDate = DateTime.now();
                                    String formattedDate = DateFormat('dd-MM-yyyy').format(currentDate);

                                    final retrievedAssignment = RetrievedAssignment(
                                      studentName: assignment['studentName'],
                                      studentSurname: assignment['studentSurname'],
                                      materialName: translateMaterial(assignment['materialName']),
                                      quantity: assignment['quantity'],
                                      selectedValue: selectedValue,
                                      date: formattedDate,
                                    );
                                    await RetrievedAssignmentDatabaseHelper.instance.insertRetrievedAssignment(retrievedAssignment);
                                    deleteAssignment(assignment);
                                    Navigator.of(context).pop();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("retrievedMessage".tr),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "retrieve".tr,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Expanded(
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ListTile(
                                  title: Text(
                                    '${assignment['studentName']} ${assignment['studentSurname']} | ${assignment['date']}',
                                  ),
                                  subtitle: Text(
                                    assignment['materialName'].toString().tr +
                                        " " +
                                        "-" +
                                        " " +
                                        '${assignment['quantity']}',
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('confirmation'.tr),
                                            content:
                                                Text('retrieveDeleteQuestion'.tr),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  deleteAssignment(assignment);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('yes'.tr),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('no'.tr),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
