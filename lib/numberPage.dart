// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:parcacii/add_student.dart';
import 'package:parcacii/for_list_page/listing_database_helper.dart';
import 'ogrenci_database_helper/ogrenci.dart';
import 'for_list_page/listing_class.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class NumberPage extends StatefulWidget {
  final int? materialId;
  final String? materialName;
  final Ogrenci student;
  final Listing ilkDeger;
  final int? date;
  const NumberPage(
      {Key? key,
      required this.materialId,
      required this.materialName,
      required this.student,
      required this.ilkDeger,
      required this.date})
      : super(key: key);

  @override
  _NumberPageState createState() => _NumberPageState();
}

TextEditingController _quantityController = TextEditingController();
final _formKey = GlobalKey<FormState>();

class _NumberPageState extends State<NumberPage> {
  int quantity = 0;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: Text('numberPage'.tr),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 300,
                child: TextFormField(
                  maxLines: null,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  controller: _quantityController,
                  decoration: InputDecoration(
                      labelText: "inputValue".tr,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "inputValueError".tr;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      try {
                        quantity = int.parse(value);
                      } catch (e) {
                        quantity = 0;
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: (() async {
                    if (_formKey.currentState!.validate()) {
                      final quantity = int.parse(_quantityController.text);

                      final dbHelper = ListingDatabaseHelper();
                      DateTime currentDate = DateTime.now();
                      String formattedDate =
                          DateFormat('dd-MM-yyyy').format(currentDate);
                      await dbHelper.insertAssignment(
                          studentName: widget.student.ad!,
                          studentSurname: widget.student.soyad!,
                          materialName: widget.materialName!,
                          quantity: quantity,
                          date: formattedDate);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: const Duration(seconds: 2),
                          content: Text("assignedMessage".tr)));
                    }

                    Navigator.of(context).pop();
                  }),
                  child: Text("assignButton".tr))
            ],
          ),
        ),
      ),
    );
  }
}
