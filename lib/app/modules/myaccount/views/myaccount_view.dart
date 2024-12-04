import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';
import 'package:myapp/component/app_color.dart';

import '../controllers/myaccount_controller.dart';

class MyaccountView extends GetView<MyaccountController> {
  const MyaccountView({super.key});
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
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
        title: const Text('Akun Saya'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            const Text(
              "Informasi Akun",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection("users")
                  .doc(user?.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return const Text("Erorr loading data");
                }
                if (snapshot.hasData && snapshot.data != null) {
                  String username = snapshot.data!['username'] ?? 'Pengguna';
                  String email = snapshot.data!['email'] ?? 'Pengguna';

                  return Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person, color: Colors.orangeAccent),
                        title: const Text("Username"),
                        subtitle: Text(username),
                      ),
                      const Divider(),
                      // Email
                      ListTile(
                        leading: const Icon(Icons.email, color: Colors.orangeAccent),
                        title: const Text("Email"),
                        subtitle: Text(email),
                      ),
                    ],
                  );
                }
                return const Text('Pengguna');
              },
            ),

            const Divider(),
            const SizedBox(height: 24),
            // Reset Password Button
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Aksi untuk reset password
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Reset Password",
                            style: TextStyle(color: Colors.white)),
                        content: const Text(
                            "Jika anda klik lanjutkan Anda akan dilanjutkan kehalaman reset password"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Tutup"),
                          ),
                          TextButton(
                              onPressed: () {
                                Get.toNamed(Routes.RESET_PASSWORD);
                              },
                              child: const Text("Lanjutkan"))
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.lock_reset,
                  color: Colors.white,
                ),
                label: const Text(
                  "Reset Password",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
