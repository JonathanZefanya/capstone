import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ServiceController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxList<Map<String, dynamic>> expressList = RxList<Map<String, dynamic>>([]);
  RxList<Map<String, dynamic>> cuciLipatList = RxList<Map<String, dynamic>>([]);
  RxList<Map<String, dynamic>> cuciSetrikaList = RxList<Map<String, dynamic>>([]);

  RxList<Map<String, dynamic>> filteredexpressList =
      RxList<Map<String, dynamic>>([]);
  RxList<Map<String, dynamic>> filteredcuciLipatList =
      RxList<Map<String, dynamic>>([]);
  RxList<Map<String, dynamic>> filteredcuciSetrikaList =
      RxList<Map<String, dynamic>>([]);

  RxBool isLoading = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    fetchservice();
  }

  void fetchservice() async {
    try {
      isLoading.value = true;

      // Fetch express products
      firestore.collection('service_express').snapshots().listen((snapshot) {
        expressList.value = snapshot.docs.map((doc) {
          var data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
        filteredexpressList.value = expressList.toList();
      });

      // Fetch Cuci Lipat products
      firestore
          .collection('service_cuciLipat')
          .snapshots()
          .listen((snapshot) {
        cuciLipatList.value = snapshot.docs.map((doc) {
          var data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
        filteredcuciLipatList.value = cuciLipatList.toList();
      });

      // Fetch cuciSetrika products
      firestore.collection('service_cuciSetrika').snapshots().listen((snapshot) {
        cuciSetrikaList.value = snapshot.docs.map((doc) {
          var data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
        filteredcuciSetrikaList.value = cuciSetrikaList.toList();
      });

      isLoading.value = false;
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat service: $e');
      isLoading.value = false;
    }
  }

  void filterserviceByCategory(String category) {
    switch (category) {
      case 'express':
        filteredexpressList.value = expressList.toList();
        break;
      case 'cuciLipat':
        filteredcuciLipatList.value = cuciLipatList.toList();
        break;
      case 'cuciSetrika':
        filteredcuciSetrikaList.value = cuciSetrikaList.toList();
        break;
      default:
        Get.snackbar('Error', 'Kategori tidak valid');
    }
  }

  void searchservice(String query, String category) {
    var lowercaseQuery = query.toLowerCase();
    switch (category) {
      case 'express':
        filteredexpressList.value = expressList
            .where((service) => service['nama']
                .toString()
                .toLowerCase()
                .contains(lowercaseQuery))
            .toList();
        break;
      case 'cuciLipat':
        filteredcuciLipatList.value = cuciLipatList
            .where((service) => service['nama']
                .toString()
                .toLowerCase()
                .contains(lowercaseQuery))
            .toList();
        break;
      case 'cuciSetrika':
        filteredcuciSetrikaList.value = cuciSetrikaList
            .where((service) => service['nama']
                .toString()
                .toLowerCase()
                .contains(lowercaseQuery))
            .toList();
        break;
      default:
        Get.snackbar('Error', 'Kategori tidak valid');
    }
  }

  void deleteservice(String id, String category) async {
    try {
      isLoading.value = true;

      await firestore
          .collection(getCategoryCollection(category))
          .doc(id)
          .delete();
      fetchservice(); // Refresh service list after deleting

      Get.snackbar('Success', 'service berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus service: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String getCategoryCollection(String category) {
    switch (category) {
      case 'express':
        return 'service';
      case 'cuciLipat':
        return 'service_cuciLipat';
      case 'cuciSetrika':
        return 'cuciSetrika';
      default:
        throw Exception('Kategori tidak valid');
    }
  }
}
