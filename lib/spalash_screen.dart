import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';
import 'package:myapp/component/app_color.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed(Routes.HOME);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Bagian atas untuk logo dan nama aplikasi
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Gambar logo
                Image.asset(
                  'assets/images/logo.png',
                  width: 150,
                  height: 150,
                ),
              ],
            ),
          ),

          // Teks "By HoneyComb" di bagian paling bawah
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(16.0), // Jarak dari bawah
              child: Text(
                "By HoneyComb",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey, // Warna abu-abu untuk teks
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
