import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../widgets/components.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterScreen> {
  bool issecure = true;
  bool isloading = false;
  TextEditingController emailaddress = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController username = TextEditingController();
  // final DateTime now = DateTime.now();
  // final DateFormat formatter = DateFormat('yyyy-MM-dd');
  @override
  void initState() {
    emailaddress.text = "";
    password.text = "";
    username.text = "";
    isloading = false;
    super.initState();
  }

  @override
  void dispose() {
    emailaddress.dispose();
    password.dispose();
    username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //============================Validate Email==================================
    bool validateEmail(String email) {
      const pattern = r'^[a-zA-Z0-9._%+-]+@(gmail\.com|outlook\.com)$';
      final regex = RegExp(pattern);
      return regex.hasMatch(email);
    }

    //============================Register user==================================
    Future<void> signupUser({
      required String email,
      required String password,
      required String name,
    }) async {
      try {
        if (validateEmail(email) == false) {
          Get.snackbar("😒", " @gmail او @outlook البريد الالكترونى غير صحيح",
              backgroundColor: Colors.white, colorText: Colors.red);
          // isloading = false;

          return;
        }
        if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
          // var random = Random();
          // var userid = name + random.nextInt(1000).toString();

          isloading = true;
          setState(() {});
          // register user in auth with email and password
          UserCredential cred =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          //==== add user to your  firestore database=================

          await FirebaseFirestore.instance
              .collection("users")
              .doc(cred.user!.uid)
              .set({
            'name': name,
            'uid': cred.user!.uid,
            'email': email,
          });

          isloading = false;
          setState(() {});
          // Get.snackbar("👍", "تم التسجيل بنجاح",
          //     backgroundColor: Colors.white, colorText: Colors.red);

          Get.offAll(() => const LoginScreen());
        } else {
          Get.snackbar("😒", "تأكد من ملىء جميع الخانات",
              backgroundColor: Colors.white, colorText: Colors.red);
        }
      } catch (err) {
        if (err.toString() ==
            "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
          Get.snackbar("😒", "الايميل مستخدم من قبل",
              backgroundColor: Colors.white, colorText: Colors.red);
          isloading = false;
          setState(() {});
        } else {
          Get.snackbar("😒", err.toString(),
              backgroundColor: Colors.amber, colorText: Colors.red);
          isloading = false;
          setState(() {});
        }
      }
    }

    //===================================================================================
    return SafeArea(
        child: AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(children: [
            Container(
              width: Get.width,
              height: Get.height * .3,
              padding: EdgeInsets.only(top: Get.height * .15, left: 15),
              decoration: const BoxDecoration(),
              //child: Lottie.asset("assets/animations/login.json.json"),
              child: Image.asset(
                "assets/images/sign_up.png",
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              margin: EdgeInsets.only(top: Get.height * .3),
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(
                  color: HexColor("f5f5f5"),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: Column(children: [
                const SizedBox(
                  height: 30.0,
                ),
                CustomForm(
                  text: "ادخل اسمك",
                  type: TextInputType.name,
                  name: username,
                  sufxicon: const Icon(Icons.person),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                CustomForm(
                  text: "ادخل ايميلك",
                  type: TextInputType.emailAddress,
                  name: emailaddress,
                  sufxicon: const Icon(Icons.email),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                CustomPass(
                    text: "ادخل كلمة المرور",
                    type: TextInputType.visiblePassword,
                    issecure: issecure,
                    name: password,
                    sufxicon: InkWell(
                      onTap: () {
                        issecure = !issecure;
                        setState(() {});
                      },
                      child: Icon(
                          issecure ? Icons.visibility_off : Icons.visibility),
                    )),
                const SizedBox(
                  height: 30.0,
                ),
                GestureDetector(
                    onTap: () {
                      signupUser(
                          email: emailaddress.text,
                          password: password.text,
                          name: username.text);
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              HexColor("666666"),
                              HexColor("333333"),
                              HexColor("101010")
                            ]),
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                            child: isloading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : const Center(
                                    child: Text(
                                    "تسجيل الدخول",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ))))),
                const SizedBox(
                  height: 30.0,
                ),
                Row(
                  children: [
                    const Center(
                        child: Text(
                      "لديك حساب بالفعل؟",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )),
                    TextButton(
                        onPressed: () {
                          Get.to(() => const LoginScreen());
                        },
                        child: const Text("تسجيل الدخول",
                            style: TextStyle(fontWeight: FontWeight.bold)))
                  ],
                ),
              ]),
            )
          ]),
        ),
      ),
    ));
  }
}
