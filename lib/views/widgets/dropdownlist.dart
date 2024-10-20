import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../controller/customers_controller.dart';

class FirebaseDropdownMenuItem extends StatefulWidget {
  const FirebaseDropdownMenuItem({super.key});

  @override
  State<FirebaseDropdownMenuItem> createState() =>
      _FirebaseDropdownMenuItemState();
}

class _FirebaseDropdownMenuItemState extends State<FirebaseDropdownMenuItem> {
  @override
  Widget build(BuildContext context) {
    AddClientsController controller = Get.put(AddClientsController());
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection("companies")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text("Some error occured ${snapshot.error}"),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Some error occured ${snapshot.error}"),
            );
          } else {
            List<DropdownMenuItem> companiesname = [];
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            final selectcompany = snapshot.data?.docs.reversed.toList();
            if (selectcompany != null) {
              for (var company in selectcompany) {
                companiesname.add(
                  DropdownMenuItem(
                    value: company['companyname'],
                    child: Text(
                      company['companyname'],
                    ),
                  ),
                );
              }
            }
            return DropdownButton(
              underline: Container(
                height: 2,
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(12),
              dropdownColor: Colors.white,
              isExpanded: false,
              hint: const Text("اختر اسم الشركه"),
              items: companiesname,
              value: controller.selectedValue.isNotEmpty
                  ? controller.selectedValue
                  : null,
              onChanged: (value) {
                setState(() {
                  controller.selectedValue = value.toString();
                  log(controller.selectedValue);
                });
              },
            );
          }
        });
  }
}