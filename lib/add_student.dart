import 'package:flutter/material.dart';
import 'package:parcacii/ogrenci_database_helper/ogrenci.dart';
import 'package:parcacii/ogrenci_database_helper/ogrenci_database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:parcacii/ogrenci_database_helper/database_helper.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddStudentState createState() => _AddStudentState();
}

TextEditingController adCont = TextEditingController();
TextEditingController soyadCont = TextEditingController();
TextEditingController numaraCont = TextEditingController();
TextEditingController sinifCont = TextEditingController();
TextEditingController subeCont = TextEditingController();
final _formKey = GlobalKey<FormState>();

class _AddStudentState extends State<AddStudent> {
  void initState() {
    super.initState();
    adCont.text = '';
    soyadCont.text = '';
    numaraCont.text = '';
    sinifCont.text = '';
    subeCont.text = '';
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: Text("firstButton".tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: Row(
                          children: [
                            const Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            ),
                            Text(
                              "studentName".tr,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "fillBoxError".tr;
                            }
                            return null;
                          },
                          controller: adCont,
                          onChanged: (text) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                              suffixIcon: adCont.text.isNotEmpty
                                  ? MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                          onTap: () {
                                            adCont.clear();
                                            setState(() {});
                                          },
                                          child: const Icon(Icons.close,
                                              color: Colors.grey)),
                                    )
                                  : null,
                              //prefixIcon: Icon(CupertinoIcons.person_fill),
                              hoverColor: Colors.transparent,
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 241, 241, 241),
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        child: Row(
                          children: [
                            const Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            ),
                            Text(
                              "studentSurname".tr,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "fillBoxError".tr;
                            }
                            return null;
                          },
                          controller: soyadCont,
                          onChanged: (text) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                              suffixIcon: soyadCont.text.isNotEmpty
                                  ? MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                          onTap: () {
                                            soyadCont.clear();
                                            setState(() {});
                                          },
                                          child: const Icon(Icons.close,
                                              color: Colors.grey)),
                                    )
                                  : null,
                              //prefixIcon: Icon(CupertinoIcons.person_fill),
                              hoverColor: Colors.transparent,
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 241, 241, 241),
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        child: Row(
                          children: [
                            const Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            ),
                            Text(
                              "studentNumber".tr,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "fillBoxError".tr;
                            }
                            return null;
                          },
                          controller: numaraCont,
                          onChanged: (text) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                              suffixIcon: numaraCont.text.isNotEmpty
                                  ? MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                          onTap: () {
                                            numaraCont.clear();
                                            setState(() {});
                                          },
                                          child: const Icon(Icons.close,
                                              color: Colors.grey)),
                                    )
                                  : null,
                              //prefixIcon: Icon(CupertinoIcons.number),
                              hoverColor: Colors.transparent,
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 241, 241, 241),
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        child: Row(
                          children: [
                            const Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            ),
                            Text(
                              "studentClass".tr,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          width: double.infinity,
                          child: DropdownButtonFormField<int>(
                            value: sinifCont.text.isNotEmpty
                                ? int.parse(sinifCont.text)
                                : null,
                            items: [9, 10, 11, 12].map((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                            onChanged: (int? value) {
                              setState(() {
                                sinifCont.text = value.toString();
                              });
                            },
                            decoration: InputDecoration(
                              hoverColor: Colors.transparent,
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 241, 241, 241),
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        child: Row(
                          children: [
                            const Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            ),
                            Text(
                              "studentBranch".tr,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          width: double.infinity,
                          child: DropdownButtonFormField<String>(
                            value:
                                subeCont.text.isNotEmpty ? subeCont.text : null,
                            items: List.generate(26, (index) {
                              return DropdownMenuItem<String>(
                                value: String.fromCharCode(65 + index),
                                child: Text(String.fromCharCode(65 + index)),
                              );
                            }),
                            onChanged: (String? value) {
                              setState(() {
                                subeCont.text = value!;
                              });
                            },
                            decoration: InputDecoration(
                              hoverColor: Colors.transparent,
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 241, 241, 241),
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          Database dbHelper =
                              await DatabaseHelper.instance.database;
                          Ogrenci yeniOgrenci = Ogrenci(
                              ad: adCont.text,
                              soyad: soyadCont.text,
                              numara: numaraCont.text,
                              sinif: sinifCont.text,
                              sube: subeCont.text);
                          UserDatabaseHelper.createUser(yeniOgrenci)
                              .then((value) {
                            if (value > 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration: const Duration(seconds: 2),
                                      content: Text('savedMessage'.tr)));
                              Navigator.of(context).pop();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration: const Duration(seconds: 2),
                                      content: Text('errorMessage'.tr)));
                            }
                          });
                        }
                      },
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Text(
                                "addButton".tr,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                /* ElevatedButton(
                    onPressed: () {
                      Ogrenci yeniOgrenci = Ogrenci(
                          ad: adCont.text,
                          soyad: soyadCont.text,
                          numara: int.parse(numaraCont.text),
                          sinif: int.parse(sinifCont.text),
                          sube: subeCont.text);
                    },
                    child: const Text("Ekle")) */
              ],
            ),
          ),
        ),
      ),
    );
  }
}
