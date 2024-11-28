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
        title: const Text('Akun Saya'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            Text(
              "Informasi Akun",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),

            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection("users")
                  .doc(user?.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text("Erorr loading data");
                }
                if (snapshot.hasData && snapshot.data != null) {
                  String username = snapshot.data!['username'] ?? 'Pengguna';
                  String email = snapshot.data!['email'] ?? 'Pengguna';

                  return Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.person, color: Colors.orangeAccent),
                        title: Text("Username"),
                        subtitle: Text(username),
                      ),
                      Divider(),
                      // Email
                      ListTile(
                        leading: Icon(Icons.email, color: Colors.orangeAccent),
                        title: Text("Email"),
                        subtitle: Text(email),
                      ),
                    ],
                  );
                }
                return Text('Pengguna');
              },
            ),

            Divider(),
            SizedBox(height: 24),
            // Reset Password Button
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                        title: Text("Reset Password",
                            style: TextStyle(color: Colors.white)),
                        content: Text(
                            "Jika anda klik lanjutkan Anda akan dilanjutkan kehalaman reset password"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Tutup"),
                          ),
                          TextButton(
                              onPressed: () {
                                Get.toNamed(Routes.RESET_PASSWORD);
                              },
                              child: Text("Lanjutkan"))
                        ],
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.lock_reset,
                  color: Colors.white,
                ),
                label: Text(
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
