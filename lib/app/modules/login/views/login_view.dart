import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';
import 'package:myapp/component/app_color.dart';
import 'package:myapp/component/custom_field.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Selamat Datang Kembali !",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
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
                  SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => CustomFormField(
                      controller: controller.passwordController,
                      hintText: "Masukkan Kata Sandi",
                      obscureText: controller.isPasswordHidden.value,
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
                      suffixIcon: controller.isPasswordHidden.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      onSuffixIconTap: controller.togglePasswordVisibility,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed(Routes.RESET_PASSWORD);
                      },
                      child: Text("Lupa Kata Sandi?"),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.login(
                          controller.emailController.text,
                          controller.passwordController.text,
                        );
                      },
                      child: Text(
                        "Masuk",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: AppColors.primary,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Belum punya akun?"),
                        TextButton(
                          onPressed: () {
                            Get.toNamed(
                                '/register'); // Navigasi ke halaman register
                          },
                          child: Text(
                            "Daftar Sekarang",
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
