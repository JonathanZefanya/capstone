import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
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
}
