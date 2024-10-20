// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../controller/customers_controller.dart';

class Alertdialog extends StatelessWidget {
  final addcompany;

  const Alertdialog({
    super.key,
    required this.addcompany,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddClientsController>(
      builder: (AddClientsController controller) => AlertDialog(
        actions: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: TextField(
              controller: addcompany,
              decoration: InputDecoration(
                  hintText: "اسم الشركه",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  )),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where("uid",
                        isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) =>
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white),
                        onPressed: () {
                          controller
                              .addCompanies(snapshot.data?.docs[0]['uid']);
                          Get.back();
                        },
                        child: const Text(
                          "اضافة الشركه",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        )),
              ),
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.cancel))
            ],
          ),
        ],
      ),
    );
  }
}