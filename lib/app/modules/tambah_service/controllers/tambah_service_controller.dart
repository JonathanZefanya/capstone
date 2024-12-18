import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TambahServiceController extends GetxController {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Connectivity connectivity = Connectivity();

  // Field untuk menyimpan kategori yang dipilih
  RxString selectedKategori = RxString('');

  @override
  void onInit() {
    super.onInit();
    selectedKategori.value = 'express'; // Default kategori
  }

  void tambahProduk(String namaProduk, double harga, String kategori) async {
    if (namaProduk.isEmpty || harga <= 0) {
      Get.snackbar('Error', 'Harap lengkapi semua field');
      return;
    }

    try {
      // Menentukan collection berdasarkan kategori
      String collectionName;
      if (kategori == 'express') {
        collectionName = 'service_express';
      } else if (kategori == 'Cuci Lipat') {
        collectionName = 'service_cuciLipat';
      } else if (kategori == 'Cuci Strika') {
        collectionName = 'service_cuciPerjam';
      } else if (kategori == 'satuan') {
        collectionName = 'service_satuan';
      } else {
        Get.snackbar('Error', 'Kategori tidak valid');
        return;
      }

      await _firestore.collection(collectionName).add({
        'nama': namaProduk,
        'harga': harga,
        'kategori': kategori, // Menyimpan kategori ke dalam Firestore
        'created_at': FieldValue.serverTimestamp(),
      });
      Get.snackbar('Success', 'Service berhasil ditambahkan');
      Get.offNamed('/service'); // Kembali ke ProdukView setelah simpan

      // Membersihkan input field
      namaController.clear();
      hargaController.clear();
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan produk: $e');
    }
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
