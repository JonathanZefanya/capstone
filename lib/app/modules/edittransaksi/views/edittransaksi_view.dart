import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../component/app_color.dart';
import '../../laporan/controllers/laporan_controller.dart';
import '../controllers/edittransaksi_controller.dart';
import '../../../../component/nointernet_widget.dart';

class EditTransaksiView extends GetView<EditTransaksiController> {
  const EditTransaksiView({super.key});

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
            color: Constants.secondColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Constants.secondColor,
          ),
        ),
      ),
      body: FutureBuilder<bool>(
          future: controller.checkInternetConnection(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData && snapshot.data == true) { 
              return Padding(
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
                    DropdownButtonFormField<String>(
                      value: controller.paymentPengambilanController.text.isEmpty
                          ? null
                          : controller.paymentPengambilanController.text,
                      decoration: const InputDecoration(
                        labelText: 'Status Pesanan',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        'Sudah Di Ambil',
                        'Belum Di ambil',
                      ]
                          .map((status) => DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              ))
                          .toList(),
                      onChanged: (value) {
                        controller.paymentPengambilanController.text = value!;
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
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 45),
                        backgroundColor: Constants.errorColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // Buat dialog konfirmasi
                        Get.defaultDialog(
                          title: 'Konfirmasi',
                          middleText: 'Apakah Anda yakin ingin menghapus transaksi ini?',
                          textConfirm: 'Ya',
                          textCancel: 'Tidak',
                          confirmTextColor: Constants.scaffoldbackgroundColor,
                          onConfirm: () {
                            controller.deleteTransaksi();
                          },
                        );
                      },
                      child: const Text(
                        "Hapus",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Constants.scaffoldbackgroundColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const NoInternet();
            }
          }
        ),
    );
  }
}
