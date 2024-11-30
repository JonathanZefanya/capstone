import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../laporan/controllers/laporan_controller.dart';

class EditTransaksiController extends GetxController {
  TextEditingController paymentMethodController = TextEditingController();
  TextEditingController paymentStatusController = TextEditingController();
  TextEditingController paymentPengambilanController = TextEditingController();

  void updateTransaksi() async {
    var laporan = Get.find<LaporanController>().selectedLaporan.value;

    // Debugging: Print ID Dokumen

    try {
      await FirebaseFirestore.instance
          .collection('laporanTransaksi')
          .doc(laporan['id'])
          .update({
        'metode_pembayaran': paymentMethodController.text,
        'status_pembayaran': paymentStatusController.text,
        'status_pengambilan': paymentPengambilanController.text,
      });

      Get.back();
      Get.snackbar('Success',
          'Transaction updated successfully'); // Snackbar for successful update
    } catch (e) {
      // Debugging: Print Error
      Get.snackbar('Error', 'Failed to update transaction');
    }
  }

  void deleteTransaksi() async {
    var laporan = Get.find<LaporanController>().selectedLaporan.value;

    try {
      await FirebaseFirestore.instance
          .collection('laporanTransaksi')
          .doc(laporan['id'])
          .delete();

      // Get ke page laporan
      Get.toNamed('/laporan');
      Get.snackbar('Success',
          'Transaction deleted successfully'); // Snackbar for successful delete
    } catch (e) {
      // Debugging: Print Error
      Get.snackbar('Error', 'Failed to delete transaction');
    }
  }
}
