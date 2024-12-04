import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myapp/app/routes/app_pages.dart';

import '../../../../component/app_color.dart';
import '../../profile/controllers/profile_controller.dart';
import '../controllers/home_controller.dart';

// ignore: must_be_immutable
class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final ProfileController profileController = Get.put(ProfileController());
  final user = FirebaseAuth.instance.currentUser;

  DateTime? currentBackPressTime;

  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Get.snackbar(
        'Peringatan',
        'Tekan kembali sekali lagi untuk keluar',
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    return true;
  }

  String getFormattedDateTime() {
    DateTime now = DateTime.now();
    String dayOfWeek =
        DateFormat('EEEE').format(now); // Hari dalam format panjang
    String time = DateFormat('HH:mm').format(now); // Jam dalam format 24 jam
    return '$dayOfWeek, $time';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white, // Warna latar belakang
          elevation: 0,
          title: FutureBuilder<DocumentSnapshot>(
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
                // Mengambil username dari Firestore
                String username = snapshot.data!['username'] ?? 'Pengguna';
                String dateTime = getFormattedDateTime();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      child: Text(
                        username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Constants.primaryColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      child: Text(
                        dateTime,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Constants
                              .secondColor, // Warna untuk tanggal dan jam
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const Text('Pengguna');
            },
          ),
          actions: [
            PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: Constants.secondColor),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'Profile',
                  child: Text('Profil'),
                ),
                const PopupMenuItem(
                  value: 'Logout',
                  child: Text('Keluar'),
                ),
              ],
              onSelected: (value) {
                if (value == 'Profile') {
                  Get.toNamed(Routes.PROFILE);
                } else if (value == 'Logout') {
                  controller.logout();
                }
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          // Membungkus seluruh body dengan SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: const BoxDecoration(
                      color: Constants.fiveColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/banner.png'), // Ganti path sesuai gambar Anda
                        fit: BoxFit.cover, // Menyesuaikan ukuran gambar
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap:
                        true, // Membuat GridView menyesuaikan ukuran kontennya
                    physics:
                        const NeverScrollableScrollPhysics(), // Menonaktifkan scroll pada GridView
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.toNamed('/service');
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Constants.menucolor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/layanan.png'), // Ganti path sesuai gambar Anda
                                    fit: BoxFit
                                        .cover, // Menyesuaikan ukuran gambar
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Layanan',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed('/pelanggan');
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Constants.menucolor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(
                                  color: Colors.yellow,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/pelanggan.png'), // Ganti path sesuai gambar Anda
                                    fit: BoxFit
                                        .cover, // Menyesuaikan ukuran gambar
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Pelanggan',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed('/laporan');
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Constants.menucolor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/laporan.png'), // Ganti path sesuai gambar Anda
                                    fit: BoxFit
                                        .cover, // Menyesuaikan ukuran gambar
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                'Laporan',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed('/transaksi');
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Constants.menucolor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/transaksi.png'), // Ganti path sesuai gambar Anda
                                    fit: BoxFit
                                        .cover, // Menyesuaikan ukuran gambar
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                'Transaksi',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
