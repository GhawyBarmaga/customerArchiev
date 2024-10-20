import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';




import '../widgets/components.dart';

class EditClients extends StatefulWidget {
  final String id;
  final String name;
  final String phone;
  final String company;
  final String goverment;
  final double amount;

  const EditClients(
      {super.key,
      required this.id,
      required this.name,
      required this.phone,
      required this.company,
      required this.goverment,
      required this.amount});

  @override
  State<EditClients> createState() => _EditClientsState();
}

class _EditClientsState extends State<EditClients> {
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController company = TextEditingController();
 
  TextEditingController amount = TextEditingController();

  @override
  void initState() {
    name.text = widget.name;
    phone.text = widget.phone;
    company.text = widget.company;
  
    amount.text = widget.amount.toString();
    super.initState();
  }

  @override
  dispose() {
    name.dispose();
    phone.dispose();
    company.dispose();
  
    amount.dispose();
    super.dispose();
  }

  //==========validate the form======================
  void validateForm() {
    if (name.text == "") {
      name.text = widget.name;
    }
    if (phone.text == "") {
      phone.text = widget.phone;
    }
    if (company.text == "") {
      company.text = widget.company;
    }
   
    if (amount.text == "") {
      amount.text = widget.amount.toString();
    }
  }

  //==========update clients=====================
  void updateClients() async {
    try {
      validateForm();
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("clients")
          .doc(widget.id)
          .update({
        "name": name.text,
        "phone": phone.text,
        "company": company.text,
        
        "currentAmount": double.parse(amount.text),
       
      });
      Get.snackbar("Success", "تم التعديل بنجاح",
          backgroundColor: Colors.deepPurple, colorText: Colors.white);
    } on FirebaseException catch (e) {
      Get.snackbar("faild", e.toString(), colorText: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: const Text("تفاصيل العميل",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple)),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              width: Get.width,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              child: Column(children: [
                const SizedBox(
                  height: 20,
                ),
                CustomForm(
                  type: TextInputType.name,
                  text: "",
                  name: name,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomForm(
                  type: TextInputType.phone,
                  text: " ",
                  name: phone,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomForm(
                  type: TextInputType.name,
                  text: " ",
                  name: company,
                ),
                const SizedBox(
                  height: 20,
                ),
               
                const SizedBox(
                  height: 20,
                ),
                CustomForm(
                  type: TextInputType.number,
                  // readonly: true,
                  text: "",
                  name: amount,
                ),
                const SizedBox(height: 20.0),
                //=================================تعديل العميل==================================
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      updateClients();
                      Get.back();
                    },
                    child: const Text(
                      "تعديل بيانات العميل",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )),
                // const SizedBox(height: 20.0),
                //=================================فاتورة بيع==================================
                // ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //         backgroundColor: Colors.black,
                //         foregroundColor: Colors.white),
                //     onPressed: () {
                //       Get.dialog(AddInvoice(id: widget.id, name: widget.name));
                //     },
                //     child: const Text(
                //       " فاتورة بيع او رصيد علاج",
                //       style:
                //           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                //     )),
                // const SizedBox(height: 20.0),
                //=================================اضافة علاج يومى او شهرى==================================
                // ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //         backgroundColor: HexColor('eeeeee'),
                //         foregroundColor: Colors.black),
                //     onPressed: () {
                //       Get.to(() => ClientTransactions(id: widget.id));
                //     },
                //     child: const Text(
                //       "عرض حركات العميل",
                //       style:
                //           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                //     )),
              ])),
        ),
      ),
    );
  }
}