import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

    double totalHarga = 0;

    // Buat header CSV
    List<String> csvData = [
      "Tanggal,Pelanggan,Metode Pembayaran,Status Pembayaran,Status Pengiriman,Detail Cuci Per Jam,Detail Service,Detail Satuan,Total Harga"
    ];

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
      double hargaItem = (item['totalHarga'] ?? 0).toDouble();
      csvData.add([
        onlyDate.toString(),
        item['pelanggan']['nama pelanggan'] ?? 'Tidak Diketahui',
        item['metode_pembayaran'] ?? 'Tidak Diketahui',
        item['status_pembayaran'] ?? 'Tidak Diketahui',
        item['status_pengiriman'] ?? 'Tidak Diketahui',
        cuciPerjamDetails,
        serviceDetails,
        satuanDetails,
        hargaItem.toString(),
      ].join(','));

      totalHarga += hargaItem;
    }

    //baris baru untuk total harga
    csvData.add([
      'TOTAL',
      totalHarga.toString(), // Nilai total harga
    ].join(','));

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

      if (file.existsSync()) {
        await file.delete();
      }

      await file.writeAsString(csvData.join("\n"));
      Get.snackbar(
        "Sukses",
        "File berhasil diekspor ke folder Downloads:\n$filePath",
      );
      await OpenFile.open(filePath);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal mengekspor file: $e",
      );
    }
  }

  Future<void> exportToExcel() async {
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
        TextCellValue('Detail Cuci Per Jam'),
        TextCellValue('Detail Service'),
        TextCellValue('Detail Satuan'),
        TextCellValue('Total Harga'),
      ]);

      // Data
      int grandTotal = 0; // Untuk menyimpan total keseluruhan harga
      for (var item in filteredLaporanList) {
        String cuciPerjamDetails = (item['cuciPerjam'] as List<dynamic>?)
                ?.map((e) =>
                    "Nama: ${e['nama'] ?? '-'}, Harga: ${e['harga'] ?? '-'}, Berat: ${e['berat'] ?? '-'}")
                .join('\n') ??
            '-';
        String serviceDetails = (item['Service'] as List<dynamic>?)
                ?.map((e) =>
                    "Nama: ${e['nama'] ?? '-'}, Harga: ${e['harga'] ?? '-'}, Berat: ${e['berat'] ?? '-'}, Kategori: ${e['kategori'] ?? '-'}")
                .join('\n') ??
            '-';
        String satuanDetails = (item['Satuan'] as List<dynamic>?)
                ?.map((e) =>
                    "Nama: ${e['nama'] ?? '-'}, Harga: ${e['harga'] ?? '-'}, Jumlah: ${e['jumlah'] ?? '-'}, Kategori: ${e['kategori'] ?? '-'}")
                .join('\n') ??
            '-';

        DateTime date = (item['tanggal'] as Timestamp).toDate();
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);

        int totalHarga = (item['totalHarga'] ?? 0).toInt();
        grandTotal += totalHarga; // Tambahkan ke grand total

        // Append row
        sheetObject.appendRow([
          TextCellValue(formattedDate),
          TextCellValue(item['pelanggan']?['nama pelanggan'] ?? '-'),
          TextCellValue(item['metode_pembayaran'] ?? '-'),
          TextCellValue(item['status_pembayaran'] ?? '-'),
          TextCellValue(item['status_pengambilan'] ?? '-'),
          TextCellValue(cuciPerjamDetails ?? '-'),
          TextCellValue(serviceDetails ?? '-'),
          TextCellValue(satuanDetails ?? '-'),
          IntCellValue(totalHarga),
        ]);
      }

      // Tambahkan baris total keseluruhan
      sheetObject.appendRow([
        TextCellValue('Total'), // Label "Total" untuk merangkum semua
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        IntCellValue(grandTotal), // Total keseluruhan harga
      ]);

      Sheet sheetObject2 = excel['Pelanggan'];
      sheetObject2.appendRow([
        TextCellValue('Nama Pelanggan'),
        TextCellValue('Alamat'),
        TextCellValue('Nomor WhatsApp'),
      ]);

      for (var item in filteredLaporanList) {
        sheetObject2.appendRow([
          TextCellValue(item['pelanggan']?['nama pelanggan'] ?? '-'),
          TextCellValue(item['pelanggan']?['alamat'] ?? '-'),
          TextCellValue(item['pelanggan']?['nomor WhatsApp'] ?? '-'),
        ]);
      }

      Sheet sheetObject3 = excel['Service'];
      sheetObject3.appendRow([
        TextCellValue('Nama Service'),
        TextCellValue('Jumlah Pembelian'),
      ]);

      // Hitung jumlah tiap jenis kategori
      Map<String, int> totalPerCategory = {};
      for (var item in filteredLaporanList) {
        List<dynamic>? cuciPerjam = item['cuciPerjam'];
        List<dynamic>? service = item['Service'];
        List<dynamic>? satuan = item['Satuan'];

        // Hitung total pembelian per kategori
        for (var item in cuciPerjam ?? []) {
          String kategori = item['kategori'] ?? 'Express';
          totalPerCategory[kategori] = (totalPerCategory[kategori] ?? 0) + 1;
        }

        for (var item in service ?? []) {
          String kategori = item['kategori'] ?? 'Lainnya';
          totalPerCategory[kategori] = (totalPerCategory[kategori] ?? 0) + 1;
        }

        for (var item in satuan ?? []) {
          String kategori = item['kategori'] ?? 'Satuan';
          totalPerCategory[kategori] = (totalPerCategory[kategori] ?? 0) + 1;
        }
      }

      // Tambahkan data ke sheet
      for (var entry in totalPerCategory.entries) {
        sheetObject3.appendRow([
          TextCellValue(entry.key),
          IntCellValue(entry.value),
        ]);
      }

      try {
        var directory = Directory('/storage/emulated/0/Download/laporan-lalundry');
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }
        var path = "${directory.path}/Laporan_Transaksi.xlsx";
        var fileBytes = excel.encode();
        File file = File(path)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes!);

        print("File berhasil disimpan di: $path");
        await OpenFile.open(path);
      } catch (e) {
        Get.snackbar("Error", "Gagal mengekspor laporan: $e");
      }
    } else {
      Get.snackbar("Izin Ditolak", "Izin penyimpanan diperlukan untuk mengekspor laporan.");
    }
  }
}
