import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components.dart';

class AddInvoice extends StatefulWidget {
  final String id;
  final String name;
  const AddInvoice({super.key, required this.id, required this.name});

  @override
  State<AddInvoice> createState() => _AddInvoiceState();
}

class _AddInvoiceState extends State<AddInvoice> {
  ///===================Custom Format===========================
  String customFormat(DateTime dateTime) {
    String year = dateTime.year.toString();
    String month = dateTime.month.toString();
    String day = dateTime.day.toString();
    // String hour = dateTime.hour.toString();
    // String minute = dateTime.minute.toString();

    return '$day/$month/$year';
  }

  //==============Add Invoice================ ======================================
  void addInvoice() async {
    DateTime now = DateTime.now();
    String formattedDate = customFormat(now);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    WriteBatch batch = firestore.batch();

    CollectionReference invoices = firestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("clients")
        .doc(widget.id)
        .collection("invoices");
    DocumentReference updateclient = firestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("clients")
        .doc(widget.id);
    if (selectedOption == "فاتورة بيع") {
      batch.set(invoices.doc(), {
        "name": name.text,
        "type": "فاتورة بيع",
        "cureAmount": double.parse(cureAmount.text),
        "date": formattedDate,
        "uid": FirebaseAuth.instance.currentUser?.uid,
      });
      batch.update(updateclient, {
        "currentAmount": FieldValue.increment(-double.parse(cureAmount.text))
      });
    } else {
      batch.set(invoices.doc(), {
        "name": name.text,
        "type": "فاتورة شراء ",
        "cureAmount": double.parse(cureAmount.text),
        "date": formattedDate,
        "uid": FirebaseAuth.instance.currentUser?.uid,
      });
      batch.update(updateclient, {
        "currentAmount": FieldValue.increment(double.parse(cureAmount.text))
      });
    }
    await batch.commit().then((_) {
      Get.snackbar("success", "تمت العملية بنجاح",
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.green,
          colorText: Colors.white);
    }).catchError((error) {
      Get.snackbar("Error", error.toString());
    });
  }

//==================================================================================
  TextEditingController name = TextEditingController();
  TextEditingController cureAmount = TextEditingController();
  String selectedOption = 'فاتورة بيع';
  @override
  void initState() {
    name.text = widget.name;
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    cureAmount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        backgroundColor: Colors.white,
        actions: [
          const Center(
            child: Text(
              " اضافة فاتورة بيع او شراء   ",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomForm(
              text: "", type: TextInputType.name, name: name, readonly: true),
          const SizedBox(
            height: 20,
          ),
          CustomForm(
              text: "المبلغ", type: TextInputType.number, name: cureAmount),
          const SizedBox(
            height: 20,
          ),
          //==========================radio button===============================
          RadioListTile<String>(
            activeColor: Colors.black,
            title: const Text('فاتورة بيع'),
            value: 'فاتورة بيع',
            groupValue: selectedOption,
            onChanged: (String? value) {
              setState(() {
                selectedOption = value!;
              });
            },
          ),
          RadioListTile<String>(
            activeColor: Colors.black,
            title: const Text('فاتورة شراء'),
            value: 'شراء',
            groupValue: selectedOption,
            onChanged: (String? value) {
              setState(() {
                selectedOption = value!;
              });
            },
          ),
          const SizedBox(
            height: 20,
          ),
          const Divider(),
          //=================================================================
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.cancel)),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white),
                onPressed: () {
                  addInvoice();
                  Get.back();
                },
                child: const Text(
                  "حفظ",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                )),
          ])
        ],
      ),
    );
  }
}
