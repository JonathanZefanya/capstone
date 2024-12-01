import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';

class LaporanController extends GetxController {
  var laporanList = <Map<String, dynamic>>[].obs;
  var filteredLaporanList = <Map<String, dynamic>>[].obs;
  var selectedLaporan = {}.obs;
  var selectedMonth = 0.obs;
  var selectedYear = DateTime.now().year.obs;
  final ScreenshotController screenshotController = ScreenshotController();

  void selectLaporan(Map<String, dynamic> laporan) {
    selectedLaporan.value = laporan;
  }

  @override
  void onInit() {
    super.onInit();
    fetchLaporan();
  }

  void fetchLaporan() async {
    try {
      FirebaseFirestore.instance
          .collection('laporanTransaksi')
          .orderBy('tanggal', descending: true)
          .snapshots()
          .listen((snapshot) {
        var data = snapshot.docs.map((doc) {
          var laporan = doc.data();
          laporan['id'] = doc.id; // Simpan ID dokumen ke dalam data laporan
          return laporan;
        }).toList();
        laporanList.value = data;
        filterLaporan();
      });
    } catch (e) {
      print('Error fetching laporan: $e');
    }
  }

  void filterLaporan() {
    var month = selectedMonth.value;
    var year = selectedYear.value;
    var filteredList = laporanList.where((laporan) {
      var tanggal = (laporan['tanggal'] as Timestamp).toDate();
      return (month == 0 || tanggal.month == month) &&
          (year == 0 || tanggal.year == year);
    }).toList();
    filteredLaporanList.assignAll(filteredList);
  }

  void selectMonth(int month) {
    selectedMonth.value = month;
    filterLaporan();
  }

  void selectYear(int year) {
    selectedYear.value = year;
    filterLaporan();
  }

  void searchLaporan(String query) {
    if (query.isEmpty) {
      filterLaporan();
    } else {
      var lowercaseQuery = query.toLowerCase();
      var filteredList = laporanList.where((laporan) {
        var pelanggan = laporan['pelanggan'];
        var nama = pelanggan['nama pelanggan'].toLowerCase();
        return nama.contains(lowercaseQuery);
      }).toList();
      filteredLaporanList.assignAll(filteredList);
    }
  }

  void contactViaWhatsApp(String phoneNumber) async {
    var whatsappUrl = Uri.parse("https://wa.me/$phoneNumber");
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      print('Could not launch $whatsappUrl');
    }
  }

  Future<void> exportToCsv() async {
    if (filteredLaporanList.isEmpty) {
      Get.snackbar("Informasi", "Tidak ada data untuk diekspor.");
      return;
    }

    // Buat header CSV
    List<String> csvData = [
      "Tanggal,Pelanggan,Metode Pembayaran,Status Pembayaran,Status Pengiriman,Total Harga,Detail Cuci Per Jam,Detail Service,Detail Satuan"
    ];

    // Tambahkan data ke CSV
    for (var item in filteredLaporanList) {
      String cuciPerjamDetails = (item['cuciPerjam'] as List<dynamic>?)
              ?.map((e) =>
                  "Nama: ${e['nama']}, Harga: ${e['harga']}, Berat: ${e['berat']}")
              .join('|') ??
          '-';
      String serviceDetails = (item['Service'] as List<dynamic>?)
              ?.map((e) =>
                  "Nama: ${e['nama']}, Harga: ${e['harga']}, Berat: ${e['berat']}, Kategori: ${e['kategori']}")
              .join('|') ??
          '-';
      String satuanDetails = (item['Satuan'] as List<dynamic>?)
              ?.map((e) =>
                  "Nama: ${e['nama']}, Harga: ${e['harga']}, Jumlah: ${e['jumlah']}, Kategori: ${e['kategori']}")
              .join('|') ??
          '-';

      DateTime date = (item['tanggal'] as Timestamp).toDate();
      DateTime onlyDate = DateTime(date.year, date.month, date.day);

      // Tambahkan baris data
      csvData.add([
        onlyDate.toString(),
        item['pelanggan']['nama pelanggan'] ?? 'Tidak Diketahui',
        item['metode_pembayaran'] ?? 'Tidak Diketahui',
        item['status_pembayaran'] ?? 'Tidak Diketahui',
        item['status_pengiriman'] ?? 'Tidak Diketahui',
        item['totalHarga']?.toString() ?? '0',
        cuciPerjamDetails,
        serviceDetails,
        satuanDetails,
      ].join(','));
    }

    try {
      // Minta izin akses penyimpanan
      // var status = await Permission.storage.request();
      // if (!status.isGranted) {
      //   Get.snackbar("Error", "Izin akses penyimpanan ditolak.");
      //   return;
      // }

      // Lokasi penyimpanan di folder Downloads
      final directory = Directory('/storage/emulated/0/Download');
      if (!directory.existsSync()) {
        throw "Folder Downloads tidak ditemukan.";
      }

      // Path file
      String filePath = "${directory.path}/Laporan_Transaksi.csv";
      File file = File(filePath);

      // Tulis data ke file CSV
      await file.writeAsString(csvData.join("\n"));

      // Snackbar sukses
      Get.snackbar(
        "Sukses",
        "File berhasil diekspor ke folder Downloads:\n$filePath",
      );
    } catch (e) {
      // Snackbar error
      Get.snackbar(
        "Error",
        "Gagal mengekspor file: $e",
      );
    }
  }
}
