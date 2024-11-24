import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TambahServiceController extends GetxController {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Field untuk menyimpan kategori yang dipilih
  RxString selectedKategori = RxString('');

  @override
  void onInit() {
    super.onInit();
    selectedKategori.value = 'express'; // Default kategori
  }

  void tambahProduk(String namaProduk, double harga, String kategori) async {
    if (namaProduk.isEmpty || harga == 0) {
      Get.snackbar('Error', 'Harap lengkapi semua field');
      return;
    }

    try {
      // Menentukan collection berdasarkan kategori
      String collectionName;
      if (kategori == 'express') {
        collectionName = 'service_express';
      } else if (kategori == 'cuciLipat') {
        collectionName = 'service_cuciLipat';
      } else if (kategori == 'cuciSetrika') {
        collectionName = 'service_cuciSetrika';
      } else {
        Get.snackbar('Error', 'Kategori tidak valid');
        return;
      }

      await _firestore.collection(collectionName).add({
        'nama': namaProduk,
        if (kategori != 'cuciSetrika') 'harga': harga,
        'kategori': kategori, // Menyimpan kategori ke dalam Firestore
        'created_at': FieldValue.serverTimestamp(),
      });
      Get.snackbar('Success', 'Produk berhasil ditambahkan');
      Get.offNamed('/produk'); // Kembali ke ProdukView setelah simpan

      // Membersihkan input field
      namaController.clear();
      hargaController.clear();
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan produk: $e');
    }
  }
}
