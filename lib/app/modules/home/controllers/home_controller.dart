import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../profile/controllers/profile_controller.dart';

class HomeController extends GetxController {
  final ProfileController profileController = Get.find();
  final name = ''.obs;
  final imagePath = ''.obs;

  late String userId;

  @override
  void onInit() {
    super.onInit();
    fetchUserId();
  }

  Future<void> fetchUserId() async {
    userId = FirebaseAuth.instance.currentUser!.uid;
    await fetchData(userId);
    subscribeToDataChanges(userId); // Menambahkan langganan pembaruan data
  }

  Future<void> fetchData(String userId) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('User').doc(userId).get();
      if (snapshot.exists) {
        final userData = snapshot.data() as Map<String, dynamic>;
        name.value = userData['name'] ?? '';
        imagePath.value = userData['imagePath'] ?? '';
      } else {
        name.value = '';
        imagePath.value = '';
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void subscribeToDataChanges(String userId) {
    FirebaseFirestore.instance
        .collection('User')
        .doc(userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final userData = snapshot.data() as Map<String, dynamic>;
        name.value = userData['name'] ?? '';
        imagePath.value = userData['imagePath'] ?? '';
      } else {
        name.value = '';
        imagePath.value = '';
      }
    });
  }

  Future<void> reloadUserData() async {
    await fetchUserId();
  }
}
