import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';

class RegisterController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  // Observable boolean for password visibility
  var isObscured = true.obs;

  // Toggle the obscured state
  void toggleObscureText() {
    isObscured.value = !isObscured.value;
  }

  void register() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final username = usernameController.text.trim();

    // Validasi input
    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      Get.snackbar("Gagal", "Semua field harus diisi!");
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar("Gagal", "Email tidak valid!");
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar("Gagal", "Password dan Confirm Password tidak cocok!");
      return;
    }

    try {
      // Proses pendaftaran
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Kirim email verifikasi
      await userCredential.user!.sendEmailVerification();

      // Simpan data user ke Firestore
      final uid = userCredential.user!.uid;
      await firestore.collection('users').doc(uid).set({
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Tampilkan dialog verifikasi email
      Get.defaultDialog(
        title: 'Verify your email',
        middleText:
            'We have sent a verification link to your email. Please verify your email to continue.',
        textConfirm: 'OK',
        textCancel: 'Resend',
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.offAllNamed(Routes.LOGIN);
        },
        onCancel: () async {
          await userCredential.user!.sendEmailVerification();
          Get.snackbar('Success', 'Email verification link resent.');
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        Get.snackbar("Gagal", "Password terlalu lemah!");
      } else if (e.code == "email-already-in-use") {
        Get.snackbar("Gagal", "Email sudah terdaftar!");
      } else if (e.code == "invalid-email") {
        Get.snackbar("Gagal", "Email tidak valid!");
      } else {
        Get.snackbar("Gagal", "Terjadi kesalahan: ${e.message}");
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar(
          "Gagal", "Terjadi kesalahan saat menyimpan data. Silakan coba lagi.");
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();
    super.onClose();
  }
}
