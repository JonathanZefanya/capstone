import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myapp/component/app_color.dart';

import '../controllers/aboutus_controller.dart';

class AboutusView extends GetView<AboutusController> {
  const AboutusView({super.key});
  @override
  Widget build(BuildContext context) {
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
        title: const Text(
          'Tentang Kami',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  // Logo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo 1
                      CircleAvatar(
                        backgroundColor: Colors.white10,
                        radius: 30,
                        backgroundImage: AssetImage(
                            'assets/images/logo.png'), // Ganti dengan path logo 1
                      ),
                      SizedBox(width: 16),
                      // Logo 2
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(
                            'assets/images/learningX.jpg'), // Ganti dengan path logo 2
                      ),
                      SizedBox(width: 16),
                      // Logo 3
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(
                            'assets/images/msib.jpg'), // Ganti dengan path logo 3
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Judul
                  const Text(
                    "Ama Laundri",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Deskripsi
                  Text(
                    "Aplikasi ini dirancang untuk membantu UMKM laundry mengelola operasional mereka dengan mudah.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 24),
                  // Section Misi/Visi
                  const ListTile(
                    leading: Icon(Icons.lightbulb_outline,
                        color: Colors.orangeAccent),
                    title: Text(
                      'Misi Kami',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        "Memberikan solusi teknologi yang inovatif untuk kebutuhan sehari-hari."),
                  ),
                  const Divider(),
                  // Section Kontak
                  const ListTile(
                    leading:
                        Icon(Icons.contact_mail, color: Colors.orangeAccent),
                    title: Text(
                      'Hubungi Kami',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Email: support@ama.com"),
                  ),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      "Tim Kami",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Column(
                    children: [
                      // Anggota Tim 1
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage('assets/avatar/jojo.jpg'),
                        ),
                        title: Text("Jonatahan Natannael Zefanya"),
                        subtitle: Text("Institut Teknologi Indonesia"),
                      ),
                      Divider(),
                      // Anggota Tim 2
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/avatar/bryan.jpg'),
                        ),
                        title: Text("Bryan Hanggara"),
                        subtitle: Text("Universitas Sriwijaya"),
                      ),
                      Divider(),
                      // Anggota Tim 3
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage('assets/avatar/rian.jpg'),
                        ),
                        title: Text("Rian Satria Permana"),
                        subtitle: Text(
                            "Sekolah Tinggi Teknologi Terpadu Nurul Fikri"),
                      ),
                      Divider(),
                      // Anggota Tim 4
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/avatar/yohanna.jpg'),
                        ),
                        title: Text("Yohanna Gloria"),
                        subtitle: Text("Universitas Paramadina"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
