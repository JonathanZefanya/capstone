import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ServiceController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxList<Map<String, dynamic>> expressList = RxList<Map<String, dynamic>>([]);
  RxList<Map<String, dynamic>> cuciLipatList = RxList<Map<String, dynamic>>([]);
  RxList<Map<String, dynamic>> cuciPerjamList = RxList<Map<String, dynamic>>([]);
    RxList<Map<String, dynamic>> satuanList = RxList<Map<String, dynamic>>([]);

  RxList<Map<String, dynamic>> filteredexpressList =
      RxList<Map<String, dynamic>>([]);
  RxList<Map<String, dynamic>> filteredcuciLipatList =
      RxList<Map<String, dynamic>>([]);
  RxList<Map<String, dynamic>> filteredcuciPerjamList =
      RxList<Map<String, dynamic>>([]);
  RxList<Map<String, dynamic>> filteredsatuanList =
      RxList<Map<String, dynamic>>([]);

  RxBool isLoading = RxBool(false);
  final Connectivity connectivity = Connectivity();

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
      firestore.collection('service_cuciLipat').snapshots().listen((snapshot) {
        cuciLipatList.value = snapshot.docs.map((doc) {
          var data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
        filteredcuciLipatList.value = cuciLipatList.toList();
      });

      // Fetch Cuci Strika products
      firestore.collection('service_cuciPerjam').snapshots().listen((snapshot) {
        cuciPerjamList.value = snapshot.docs.map((doc) {
          var data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
        filteredcuciPerjamList.value = cuciPerjamList.toList();
      });

      // Fetch satuan products
      firestore.collection('service_satuan').snapshots().listen((snapshot) {
        satuanList.value = snapshot.docs.map((doc) {
          var data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
        filteredsatuanList.value = satuanList.toList();
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
      case 'Cuci Lipat':
        filteredcuciLipatList.value = cuciLipatList.toList();
        break;
      case 'Cuci Strika':
        filteredcuciPerjamList.value = cuciPerjamList.toList();
        break;
      case 'satuan':
        filteredsatuanList.value = satuanList.toList();
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
      case 'Cuci Lipat':
        filteredcuciLipatList.value = cuciLipatList
            .where((service) => service['nama']
                .toString()
                .toLowerCase()
                .contains(lowercaseQuery))
            .toList();
        break;
      case 'Cuci Strika':
        filteredcuciPerjamList.value = cuciPerjamList
            .where((service) => service['nama']
                .toString()
                .toLowerCase()
                .contains(lowercaseQuery))
            .toList();
        break;
      case 'satuan':
        filteredsatuanList.value = satuanList
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
        return 'service_express';
      case 'Cuci Lipat':
        return 'service_cuciLipat';
      case 'Cuci Strika':
        return 'service_cuciPerjam';
      case 'satuan':
        return 'service_satuan';
      default:
        throw Exception('Kategori tidak valid');
    }
  }

    Future<bool> checkInternetConnection() async {
    var connectivityResult = await connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
