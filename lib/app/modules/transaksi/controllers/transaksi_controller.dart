import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TransaksiController extends GetxController {
  var selectedPelanggan = {}.obs;
  var selectedcuciSetrika = <Map<String, dynamic>>[].obs;
  var selectedService = <Map<String, dynamic>>[].obs;
  var metodePembayaran = 'Cash'.obs;
  var statusPembayaran = 'Lunas'.obs;
  var statusPengiriman = 'Diantar'.obs;
  var totalHarga = 0.0.obs;

  void selectPelanggan(Map<String, dynamic> pelanggan) {
    selectedPelanggan.value = pelanggan;
  }

  void addcuciSetrika(Map<String, dynamic> cuciSetrika) {
    selectedcuciSetrika.add(cuciSetrika);
  }

  void removecuciSetrika(int index) {
    selectedcuciSetrika.removeAt(index);
  }

  void addService(Map<String, dynamic> Service) {
    selectedService.add(Service);
  }

// Select and remove Service and update jumlah Service
  void selectService(Map<String, dynamic> Service) {
    Service['jumlah'] = 0.0; // Default jumlah Service adalah 1
    selectedService.add(Service);
    _hitungTotalHarga();
  }

  void removeService(int index) {
    selectedService.removeAt(index);
    _hitungTotalHarga();
  }

  void updateJumlahService(int index, double jumlah) {
    selectedService[index]['jumlah'] = jumlah;
    _hitungTotalHarga();
  }

// Hitung total harga
  void _hitungTotalHarga() {
    double total = 0;
    for (var Service in selectedService) {
      double harga = Service['harga'] != null && Service['harga'] is num
          ? (Service['harga'] as num).toDouble()
          : 0.0;
      double jumlah = Service['jumlah'] != null && Service['jumlah'] is num
          ? (Service['jumlah'] as num).toDouble()
          : 0.0;
      total += harga * jumlah;
    }
    totalHarga.value = total;
  }

  Future<void> saveTransaksi() async {
    try {
      var transaksiData = {
        'pelanggan': selectedPelanggan.value,
        'cuciSetrika': selectedcuciSetrika.map((e) => e['nama']).toList(),
        'Service': selectedService
            .map((e) => {
                  'nama': e['nama'],
                  'harga': e['harga'],
                  'jumlah': e['jumlah'],
                })
            .toList(),
        'metode_pembayaran': metodePembayaran.value,
        'status_pembayaran': statusPembayaran.value,
        'status_pengiriman': statusPengiriman.value,
        'totalHarga': totalHarga.value,
        'tanggal': Timestamp.now(),
      };

      await FirebaseFirestore.instance
          .collection('laporanTransaksi')
          .add(transaksiData);
      Get.snackbar('Success', 'Transaksi berhasil disimpan');
      clearSelections();
    } catch (e) {
      throw Exception('Failed to save transaction: $e');
    }
  }

  void clearSelections() {
    selectedPelanggan.value = {};
    selectedcuciSetrika.clear();
    selectedService.clear();
    metodePembayaran.value = 'Cash';
    statusPembayaran.value = 'Lunas';
    statusPengiriman.value = 'Diantar';
    totalHarga.value = 0;
    totalHarga.refresh();
  }
}
