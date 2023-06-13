import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parcacii/add_student.dart';
import 'package:parcacii/assignedPage.dart';
import 'package:parcacii/broken_normal_page.dart';
import 'package:parcacii/student_list.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';


class HomePage extends StatelessWidget {
  final List locale = [
    {'name': "English", 'locale': const Locale('en', 'US')},
    {'name': "Türkçe", 'locale': const Locale('tr', 'TR')},
  ];

  updateLanguage(Locale locale) {
    Get.back();
    Get.updateLocale(locale);
  }

  HomePage({super.key});

  buildDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: Text("chooseLang".tr),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () {
                            updateLanguage(locale[index]['locale']);
                          },
                          child: Text(locale[index]['name'])),
                    );
                  }),
                  separatorBuilder: ((context, index) {
                    return const Divider(
                      color: Colors.orange,
                    );
                  }),
                  itemCount: locale.length),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      floatingActionButton: Text("Credit".tr),
      appBar: AppBar(
        title: Text('home'.tr),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton(
              onPressed: (() {
                buildDialog(context);
              }),
              child: Text("changeLang".tr))
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 30), // Add some empty space at the top
            const SizedBox(
              height: 175,
            ),
            SizedBox(
              width: 215,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AddStudent()));
                },
                label: Text("firstButton".tr),
                icon: const Icon(Icons.person_add),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 215,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const StudentList()));
                },
                label: Text("secondButton".tr),
                icon: const Icon(Icons.list),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 215,
              child: ElevatedButton.icon(
                  onPressed: (() {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AssignedPage()));
                  }),
                  icon: const Icon(CupertinoIcons.list_bullet_indent),
                  label: Text("fourthButton".tr)),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 215,
              child: ElevatedButton.icon(
                  onPressed: (() {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            const RetrievedAssignmentsPage()));
                  }),
                  icon: const Icon(CupertinoIcons.list_bullet_below_rectangle),
                  label: Text("fifthButton".tr)),
            )
          ],
        ),
      ),
    );
  }
}
