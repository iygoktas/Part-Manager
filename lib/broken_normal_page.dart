import 'package:flutter/material.dart';
import 'retrieved_assigments/retrieved_assignments_db_helper.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class RetrievedAssignmentsPage extends StatefulWidget {
  const RetrievedAssignmentsPage({Key? key}) : super(key: key);

  @override
  _RetrievedAssignmentsPageState createState() =>
      _RetrievedAssignmentsPageState();
}

class _RetrievedAssignmentsPageState extends State<RetrievedAssignmentsPage> {
  List<Map<String, dynamic>> _retrievedAssignments = [];
  List<Map<String, dynamic>> _filteredAssignments = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    loadRetrievedAssignments();
  }

  Future<void> loadRetrievedAssignments() async {
    final dbHelper = RetrievedAssignmentDatabaseHelper.instance;
    _retrievedAssignments = await dbHelper.getRetrievedAssignments();
    _filteredAssignments = List.from(_retrievedAssignments);
    setState(() {});
  }

  Future<void> deleteRetrievedAssignment(int id) async {
    final dbHelper = RetrievedAssignmentDatabaseHelper.instance;
    await dbHelper.deleteRetrievedAssignment(id);
    loadRetrievedAssignments();
  }

  void _filterAssignments(String searchTerm) {
    setState(() {
      if (searchTerm.isEmpty) {
        _filteredAssignments = List.from(_retrievedAssignments);
      } else {
        _filteredAssignments = _retrievedAssignments
            .where((assignment) =>
                assignment['studentName']
                    .toLowerCase()
                    .contains(searchTerm.toLowerCase()) ||
                assignment['studentSurname']
                    .toLowerCase()
                    .contains(searchTerm.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                onChanged: _filterAssignments,
                decoration: InputDecoration(
                  hintText: 'searchBar'.tr,
                  hintStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              )
            : Text('fifthButton'.tr),
        centerTitle: true,
        actions: [
          IconButton(
            icon: _isSearching ? Icon(Icons.clear) : Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _filterAssignments('');
                }
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _filteredAssignments.length,
        itemBuilder: (context, index) {
          final retrievedAssignment = _filteredAssignments[index];
          final id = retrievedAssignment['id'];

          return ListTile(
            title: Text(
              '${retrievedAssignment['studentName']} ${retrievedAssignment['studentSurname']} | ${retrievedAssignment['date']}',
            ),
            subtitle: Text(
              '${retrievedAssignment['materialName'].toString().tr} - ${retrievedAssignment['quantity']} -  ${retrievedAssignment['selectedValue'] == 'Normal' ? 'Normal'.tr : 'Broken'.tr}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('confirmation'.tr),
                      content: Text('retrieveDeleteQuestion'.tr),
                      actions: [
                        TextButton(
                          onPressed: () {
                            deleteRetrievedAssignment(id);
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
            ),
          );
        },
      ),
    );
  }
}
