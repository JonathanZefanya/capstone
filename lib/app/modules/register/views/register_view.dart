import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/component/app_color.dart';
import 'package:myapp/component/custom_field.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Buat Akun Baru",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                CustomFormField(
                  controller: controller.usernameController,
                  hintText: "Masukkan Username Kamu",
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Username is required";
                    }
                    return null;
                  },
                  prefixIcon: Icons.person,
                ),
                const SizedBox(height: 10),
                CustomFormField(
                  controller: controller.emailController,
                  hintText: "Masukkan Email Kamu",
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                  prefixIcon: Icons.email,
                ),
                const SizedBox(height: 10),
                Obx(
                  () => CustomFormField(
                    controller: controller.passwordController,
                    hintText: "Masukkan Kata Sandi",
                    obscureText: controller.isObscured.value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                    prefixIcon: Icons.lock,
                    suffixIcon: controller.isObscured.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    onSuffixIconTap: controller.toggleObscureText,
                  ),
                ),
                const SizedBox(height: 10),
                Obx(
                  () => CustomFormField(
                    controller: controller.confirmPasswordController,
                    hintText: "Konfirmasi Kata Sandi",
                    obscureText: controller.isObscured.value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Confirm Password is required";
                      }
                      return null;
                    },
                    prefixIcon: Icons.lock,
                    suffixIcon: controller.isObscured.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    onSuffixIconTap: controller.toggleObscureText,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.register,
                    child: const Text(
                      "Daftar",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Sudah punya akun?"),
                    TextButton(
                      onPressed: () {
                        Get.toNamed('/login');
                      },
                      child: Text(
                        "Masuk Sekarang",
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
