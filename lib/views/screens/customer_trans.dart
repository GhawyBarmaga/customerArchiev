import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hexcolor/hexcolor.dart';

class ClientTransactions extends StatefulWidget {
  final String id;
  const ClientTransactions({super.key, required this.id});

  @override
  State<ClientTransactions> createState() => _ClientTransactionsState();
}

class _ClientTransactionsState extends State<ClientTransactions> {
  DateTime? firstDate;
  DateTime? secDate;
  //TextEditingController name = TextEditingController();
  //=========================================firstdate calender==============================
  Future pickFirstDate() async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: firstDate ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 20),
      lastDate: DateTime.now(),
    );
    if (newDate == null) {
      return;
    }
    setState(() => firstDate = newDate);
  }

//===========================================second date calender==========================
  Future pickSecDate() async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: secDate ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime.now(),
    );
    if (newDate == null) {
      return;
    }
    setState(() => secDate = newDate);
  }

//=================================================================
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
          body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(colors: [
                  HexColor("2B5876"),
                  HexColor("4E4376"),
                ])),
            child: Column(
              children: [
                const Text(
                  "البحث عن حركات العملاء",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: pickFirstDate,
                              icon: const Icon(
                                Icons.calendar_today,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              " من تاريخ ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Text(
                          firstDate == null
                              ? ""
                              : "${firstDate?.day}/${firstDate?.month}/${firstDate?.year}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            const Text("الى تاريخ ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )),
                            IconButton(
                              onPressed: pickSecDate,
                              icon: const Icon(
                                Icons.calendar_today,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Text(
                            secDate == null
                                ? " "
                                : "${secDate?.day}/${secDate?.month}/${secDate?.year}",
                            style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  thickness: 2,
                  color: Colors.black,
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: firstDate != null && secDate != null
                          ? FirebaseFirestore.instance
                              .collection("Pharmacists")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection("clients")
                              .doc(widget.id)
                              .collection("invoices")
                              .orderBy("date", descending: true)
                              .where("date",
                                  isGreaterThanOrEqualTo:
                                      "${firstDate?.day}/${firstDate?.month}/${firstDate?.year}")
                              .where("date",
                                  isLessThanOrEqualTo:
                                      "${secDate?.day}/${secDate?.month}/${secDate?.year}")
                              // .startAt([name.text])
                              // .endAt(["${name.text}\uf8ff"])

                              .snapshots()
                          : FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection("clients")
                              .doc(widget.id)
                              .collection("invoices")
                              .orderBy("date", descending: true)
                              .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator(
                            backgroundColor: Colors.deepPurple,
                          ));
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Some error occured ${snapshot.error}"),
                          );
                        } else {
                          return ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data!.docs.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      shadowColor: Colors.deepPurple,
                                      elevation: 7,
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.person,
                                          color: Colors.deepPurple,
                                          size: 40,
                                        ),
                                        title: Text(
                                          "${snapshot.data!.docs[index]['name']}",
                                        ),
                                        subtitle: RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                              text:
                                                  "${snapshot.data!.docs[index]['type']} ",
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text: snapshot.data!.docs[index]
                                                  ['date'],
                                              style: const TextStyle(
                                                  color: Colors.deepPurple,
                                                  fontWeight: FontWeight.bold))
                                        ])),
                                        trailing: Text(
                                          "${snapshot.data!.docs[index]['cureAmount']}",
                                          style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ));
                              });
                        }
                      }),
                ),
              ],
            )),
      )),
    ));
  }
}
