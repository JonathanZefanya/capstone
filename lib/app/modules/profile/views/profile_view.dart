import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myapp/app/modules/home/controllers/home_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';
import 'package:myapp/component/app_color.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final HomeController homeController = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Constants.secondColor,
          ),
        ),
        title: const Text('Profil'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 22,
                horizontal: 20,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 33,
              ),
              height: 95,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Constants.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user?.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return const Text('Error loading username');
                      }
                      if (snapshot.hasData && snapshot.data != null) {
                        String username =
                            snapshot.data!['username'] ?? 'Pengguna';
                        return Text(
                          username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      return const Text('Pengguna');
                    },
                  ),
                  const Text(
                    "Member Silver",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.person, color: AppColors.accent),
                    title: const Text(
                      'Akun Saya',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text('Buat perubahan pada akun Anda'),
                    trailing: const Icon(Icons.error_outline, color: AppColors.error),
                    onTap: () {
                      Get.toNamed(Routes.MYACCOUNT);
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    leading: const Icon(Icons.info, color: AppColors.accent),
                    title: const Text(
                      'Tentang Aplikasi',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text('Lihat informasi tentang aplikasi'),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Constants.secondColor,
                    ),
                    onTap: () {
                      Get.toNamed(Routes.ABOUTUS);
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.logout_outlined,
                      color: AppColors.accent,
                    ),
                    title: const Text(
                      'Keluar',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text('Keluar dari aplikasi'),
                    onTap: () {
                      homeController.logout();
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
