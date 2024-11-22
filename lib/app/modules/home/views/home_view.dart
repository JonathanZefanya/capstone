import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../component/app_color.dart';
import '../../profile/controllers/profile_controller.dart';
import '../controllers/home_controller.dart';

// ignore: must_be_immutable
class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final ProfileController profileController = Get.find();

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.primaryColor,
          toolbarHeight: 100,
          actions: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => CircleAvatar(
                      radius: 30,
                      child: controller.imagePath.value.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                controller.imagePath.value,
                                errorBuilder: (context, error, stackTrace) =>
                                    SvgPicture.asset(
                                  "assets/images/person.svg",
                                  fit: BoxFit.cover,
                                  width: 140,
                                  height: 140,
                                ),
                                fit: BoxFit.cover,
                                width: 140,
                                height: 140,
                              ),
                            )
                          : SvgPicture.asset(
                              "assets/images/person.svg",
                              fit: BoxFit.cover,
                              width: 140,
                              height: 140,
                            ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Selamat Datang",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      color: Constants.scaffoldbackgroundColor,
                    ),
                  ),
                  Text(
                    controller.name.value,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Constants.scaffoldbackgroundColor,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            PopupMenuButton(
              color: Constants.scaffoldbackgroundColor,
              icon: const Icon(Icons.more_vert, color: Colors.white),
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: 'Profile',
                    child: Text(
                      'Profile',
                      style: TextStyle(
                        color: Constants.primaryColor,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ];
              },
              onSelected: (value) {
                switch (value) {
                  case 'Profile':
                    Get.toNamed('/profile');
                    break;
                  default:
                }
              },
            ),
          ],
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Constants.primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/banner.png', // bisa ganti dengan banner promo ini yan
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                              Image.asset(
                                'assets/images/service.png',
                                scale: 1.4,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Service',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
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
                              Image.asset(
                                'assets/images/pelanggan.png',
                                scale: 1.4,
                              ),
                              const SizedBox(height: 30),
                              const Text(
                                'Pelanggan',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
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
                              Image.asset(
                                'assets/images/laporan.png',
                                scale: 1.4,
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                'Laporan',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
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
                              Image.asset(
                                'assets/images/transaksi.png',
                                scale: 1.4,
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                'Transaksi',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
