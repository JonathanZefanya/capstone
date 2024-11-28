import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../component/app_color.dart';
import '../../laporan/controllers/laporan_controller.dart';
import '../controllers/edittransaksi_controller.dart';

class EditTransaksiView extends GetView<EditTransaksiController> {
  const EditTransaksiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var laporan = Get.find<LaporanController>().selectedLaporan.value;
    controller.paymentMethodController.text =
        laporan['metode_pembayaran'] ?? '';
    controller.paymentStatusController.text =
        laporan['status_pembayaran'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Transaksi',
          style: TextStyle(
            fontSize: 20,
            color: Constants.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Constants.secondColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: controller.paymentMethodController.text,
              decoration: const InputDecoration(
                labelText: 'Metode Pembayaran',
                border: OutlineInputBorder(),
              ),
              items: [
                'Bayar Nanti',
                'Cash',
                'QRIS',
                'Transfer', // Add the new payment method here
              ] // Make sure there are no duplicate values here
                  .map((method) => DropdownMenuItem(
                        value: method,
                        child: Text(method),
                      ))
                  .toList(),
              onChanged: (value) {
                controller.paymentMethodController.text = value!;
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: controller.paymentStatusController.text.isEmpty
                  ? null
                  : controller.paymentStatusController.text,
              decoration: const InputDecoration(
                labelText: 'Status Pembayaran',
                border: OutlineInputBorder(),
              ),
              items: [
                'Lunas',
                'Belum Lunas',
              ]
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
              onChanged: (value) {
                controller.paymentStatusController.text = value!;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45),
                backgroundColor: Constants.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                controller.updateTransaksi();
              },
              child: const Text(
                "Simpan",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Constants.scaffoldbackgroundColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
