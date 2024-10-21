import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';



import '../../controller/customers_controller.dart';
import '../widgets/alert_dialog.dart';

import '../widgets/components.dart';
import '../widgets/dropdownlist.dart';

class AddClients extends StatefulWidget {
  const AddClients({super.key});

  @override
  State<AddClients> createState() => _AddClientsState();
}

class _AddClientsState extends State<AddClients> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor('efeee5'),
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios)),
          backgroundColor: HexColor('efeee5'),
          title: const Text(
            "اضافة عميل جديد",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: GetBuilder<AddClientsController>(
          builder: (AddClientsController controller) => SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                //width: Get.width,
                height: Get.height * 0.8,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Form(
                    key: controller.formKey,
                    child: Column(children: [
                      CustomForm(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "ادخل الاسم";
                          }
                          return null;
                        },
                        text: "اسم العميل",
                        type: TextInputType.name,
                        name: controller.name,
                      ),
                      const SizedBox(height: 10.0),
                      CustomForm(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "ادخل رقم الهاتف";
                          } else if (value.length < 11) {
                            return "الرقم غير مكتمل";
                          }
                          // else if (controller.phones.contains(value)) {
                          //   return "هذا الرقم موجود مسبقا";
                          // }

                          return null;
                        },
                        text: "رقم الهاتف",
                        formating: [LengthLimitingTextInputFormatter(11)],
                        type: TextInputType.phone,
                        name: controller.phone,
                      ),
                      const SizedBox(height: 10.0),
                      
                      const SizedBox(height: 10.0),
                      CustomForm(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "ادخل رصيد العميل";
                            }
                            return null;
                          },
                          text: "رصيد العميل",
                          type: TextInputType.number,
                          name: controller.amount),
                      const SizedBox(height: 15.0),
                      IconButton(
                          onPressed: () {
                            Get.dialog(
                                Alertdialog(addcompany: controller.addcompany));
                          },
                          icon: const Icon(Icons.add, size: 30)),
                      const Text(
                        "اضف شركه",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20.0),
                      const FirebaseDropdownMenuItem(),
                      const SizedBox(height: 20.0),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .where("uid",
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser?.uid)
                            .snapshots(),
                        builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) =>
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white),
                                onPressed: () async {
                                  //============Add clients==========================
                                  if (controller.formKey.currentState!
                                      .validate()) {
                                    controller.formKey.currentState!.save();
                                    //==========check phone number is exist or not======================
                                    await controller
                                        .getAllPhoneNumbers()
                                        .then((value) {
                                      if (value
                                          .contains(controller.phone.text)) {
                                        return Get.snackbar(
                                            "خطأ", "رقم التليفون موجود بالفعل",
                                            colorText: Colors.red);
                                      } else {
                                        controller.addClients(
                                            snapshot.data?.docs[0]['uid']);
                                      }
                                    });
                                  }
                                },
                                child: const Text(
                                  "اضافة العميل",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                      )
                    ]),
                  ),
                ),
              )),
        ));
  }
}