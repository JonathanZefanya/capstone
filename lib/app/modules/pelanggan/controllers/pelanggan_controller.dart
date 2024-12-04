import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class PelangganController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var pelangganList = <Map<String, dynamic>>[].obs;
  var filteredPelangganList = <Map<String, dynamic>>[].obs;
  final Connectivity connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    fetchPelanggan();
  }

  void fetchPelanggan() async {
    try {
      var result = await firestore.collection('pelanggan').get();
      var list = result.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      // Explicit type casting to List<Map<String, dynamic>>
      List<Map<String, dynamic>> mappedList = list.cast<Map<String, dynamic>>();

      pelangganList.assignAll(mappedList);
      filteredPelangganList.assignAll(mappedList);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat pelanggan: $e');
    }
  }

  void filterPelanggan(String query) {
    if (query.isEmpty) {
      filteredPelangganList.assignAll(pelangganList);
    } else {
      filteredPelangganList.assignAll(pelangganList.where((pelanggan) =>
          pelanggan['nama pelanggan']
              .toLowerCase()
              .contains(query.toLowerCase())));
    }
  }

  void deletePelanggan(String id) async {
    try {
      await firestore.collection('pelanggan').doc(id).delete();
      fetchPelanggan();
      Get.snackbar('Success', 'Pelanggan berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus pelanggan: $e');
    }
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
