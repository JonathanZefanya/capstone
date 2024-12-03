import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../pelanggan/controllers/pelanggan_controller.dart';

// void makeError() {
//   assert(false, "Eksekusi dihentikan di sini");
// }

class TambahPelangganController extends GetxController {
  final TextEditingController namaPelangganController = TextEditingController();
  final TextEditingController nomorWhatsAppController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Instance of PelangganController
  final PelangganController pelangganController =
      Get.find<PelangganController>();

  // Field untuk menyimpan kode negara yang dipilih
  var selectedCountryCode = '+62'.obs;
  final List<String> countryCodes = [
    '+62',
    '+1',
    '+91',
    '+44'
  ]; // Tambahkan kode negara lain sesuai kebutuhan

  void tambahPelanggan(
      String namaPelanggan, String nomorWhatsApp, String alamat) async {
    if (namaPelanggan.isEmpty || nomorWhatsApp.isEmpty || alamat.isEmpty) {
      Get.snackbar('Error', 'Harap lengkapi semua field');
      return;
    }
    // Nama pelanggan tidak boleh sama 
    if (pelangganController.pelangganList
        .any((pelanggan) => pelanggan['nama pelanggan'] == namaPelanggan)) {
      Get.snackbar('Error', 'Nama pelanggan sudah ada');
      return;
    }

    final String fullPhoneNumber = selectedCountryCode.value + nomorWhatsApp;

    try {
      await _firestore.collection('pelanggan').add({
        'nama pelanggan': namaPelanggan,
        'nomor WhatsApp': fullPhoneNumber,
        'alamat': alamat, // Menyimpan kategori ke dalam Firestore
        'created_at': FieldValue.serverTimestamp(),
      });
      Get.snackbar('Success', 'Pelanggan berhasil ditambahkan');

      // Update pelanggan list
      pelangganController.fetchPelanggan();

      Get.offNamed('/pelanggan');

      // Membersihkan input field
      namaPelangganController.clear();
      nomorWhatsAppController.clear();
      alamatController.clear();
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan pelanggan: $e');
    }
  }
}
