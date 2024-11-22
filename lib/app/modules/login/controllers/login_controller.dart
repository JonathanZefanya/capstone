import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';

class LoginController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final isPasswordHidden = true.obs;
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Stream<User?> get streamAuthStatus =>
      FirebaseAuth.instance.authStateChanges();

  void login(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Get.offAllNamed(AppPages.INITIAL);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        print("email tidak cocok");
        Get.snackbar(
          "Ups!",
          "Email Tidak Ditemukan",
        );
      } else if (e.code == "invalid-email") {
        Get.snackbar("Cek Lagi", "Email tidak valid!");
      } else if (e.code == 'wrong-password') {
        print("password tidak cocok");
        Get.snackbar(
          "Ups!",
          "Password Salah",
        );
      } else if (e.code == 'too-many-request') {
        print("terlalu banyak mencoba");
        Get.snackbar(
          "Sudah dulu ya!",
          "Terlalu banyak mencoba, ingat ingat lagi!",
        );
      } 
      print(e.code);
    } catch (e) {
      print(e);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
