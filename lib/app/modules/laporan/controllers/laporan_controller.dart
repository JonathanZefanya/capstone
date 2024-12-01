import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file/open_file.dart';

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
    final status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Laporan Transaksi'];

      // Header
      sheetObject.appendRow([
        TextCellValue('Tanggal'),
        TextCellValue('Pelanggan'),
        TextCellValue('Metode Pembayaran'),
        TextCellValue('Status Pembayaran'),
        TextCellValue('Status Pesanan'),
        TextCellValue('Total Harga'),
        TextCellValue('Detail Cuci Per Jam'),
        TextCellValue('Detail Service'),
        TextCellValue('Detail Satuan'),
      ]);

      // Data
      for (var item in filteredLaporanList) {
        String cuciPerjamDetails = (item['cuciPerjam'] as List<dynamic>?)
                ?.map((e) =>
                    "Nama: ${e['nama']}, Harga: ${e['harga']}, Berat: ${e['berat']}")
                .join('\n') ??
            '-';
        String serviceDetails = (item['Service'] as List<dynamic>?)
                ?.map((e) =>
                    "Nama: ${e['nama']}, Harga: ${e['harga']}, Berat: ${e['berat']}, Kategori: ${e['kategori']}")
                .join('\n') ??
            '-';
        String satuanDetails = (item['Satuan'] as List<dynamic>?)
                ?.map((e) =>
                    "Nama: ${e['nama']}, Harga: ${e['harga']}, Jumlah: ${e['jumlah']}, Kategori: ${e['kategori']}")
                .join('\n') ??
            '-';

        DateTime date = (item['tanggal'] as Timestamp).toDate();
        DateTime onlyDate = DateTime(date.year, date.month, date.day);

        // Append row
        sheetObject.appendRow([
          TextCellValue(onlyDate.toString()),
          TextCellValue(item['pelanggan']['nama pelanggan'] ?? 'Tidak Diketahui'),
          TextCellValue(item['metode_pembayaran'] ?? 'Tidak Diketahui'),
          TextCellValue(item['status_pembayaran'] ?? 'Tidak Diketahui'),
          TextCellValue(item['status_pengambilan'] ?? 'Tidak Diketahui'),
          IntCellValue((item['totalHarga'] ?? 0).toInt()), // Convert to int
          TextCellValue(cuciPerjamDetails),
          TextCellValue(serviceDetails),
          TextCellValue(satuanDetails),
        ]);
      }

      // Save file to storage
      try {
        var directory = await getApplicationDocumentsDirectory();
        var path = "${directory.path}/Laporan_Transaksi.xlsx";
        var fileBytes = excel.encode();
        File file = File(path)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes!);

        // Open the file after exporting
        final result = await OpenFile.open(file.path);
        if (result.type != ResultType.done) {
          Get.snackbar("Error", "Gagal membuka file: ${result.message}");
        } else {
          Get.snackbar("Sukses", "Laporan berhasil diekspor ke $path");
        }
      } catch (e) {
        Get.snackbar("Error", "Gagal mengekspor laporan: $e");
      }
    } else {
      Get.snackbar("Izin Ditolak", "Izin penyimpanan diperlukan untuk mengekspor laporan.");
    }
  }
}
