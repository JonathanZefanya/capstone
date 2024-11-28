import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';

class ResetPasswordController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
    TextEditingController emailController = TextEditingController();
  
  void resetPassword(String email) async {
    if (email != "" && GetUtils.isEmail(email)) {
      await auth.sendPasswordResetEmail(email: email);
      Get.snackbar('Sukses', 'Password reset link sudah dikirim');
      Get.offAllNamed(Routes.LOGIN);
    } else {
      Get.snackbar("Eror", "Masukkan email yang valid");  
    }
  }
}
