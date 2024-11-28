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
          icon: Icon(
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
              margin: EdgeInsets.symmetric(
                vertical: 22,
                horizontal: 20,
              ),
              padding: EdgeInsets.symmetric(
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
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error loading username');
                      }
                      if (snapshot.hasData && snapshot.data != null) {
                        String username =
                            snapshot.data!['username'] ?? 'Pengguna';
                        return Text(
                          username,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      return Text('Pengguna');
                    },
                  ),
                  Text(
                    "Member Silver",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(Icons.person, color: AppColors.accent),
                    title: Text(
                      'Akun Saya',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Buat perubahan pada akun Anda'),
                    trailing: Icon(Icons.error_outline, color: AppColors.error),
                    onTap: () {
                      Get.toNamed(Routes.MYACCOUNT);
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    leading: Icon(Icons.info, color: AppColors.accent),
                    title: Text(
                      'Tentang Aplikasi',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Lihat informasi tentang aplikasi'),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Constants.secondColor,
                    ),
                    onTap: () {
                      Get.toNamed(Routes.ABOUTUS);
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.logout_outlined,
                      color: AppColors.accent,
                    ),
                    title: Text(
                      'Keluar',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Keluar dari aplikasi'),
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
