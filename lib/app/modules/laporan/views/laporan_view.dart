import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myapp/component/search_field.dart';

import '../../../../component/app_color.dart';
import '../../detailorder/views/detailorder_view.dart';
import '../controllers/laporan_controller.dart';

class LaporanView extends GetView<LaporanController> {
  const LaporanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.toNamed('/home');
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Constants.secondColor,
          ),
        ),
        title: const Text(
          'Laporan',
          style: TextStyle(
            color: Constants.secondColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 80,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Center(
                      child: Text(
                        'Pilih Bulan dan Tahun',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    content: Obx(() {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 200,
                            child: DropdownButtonFormField<int>(
                              value: controller.selectedMonth.value,
                              items: List.generate(13, (index) {
                                if (index == 0) {
                                  return const DropdownMenuItem(
                                    value: 0,
                                    child: Text('Semua Bulan'),
                                  );
                                }
                                return DropdownMenuItem(
                                  value: index,
                                  child: Text(
                                    DateFormat('MMMM')
                                        .format(DateTime(0, index)),
                                  ),
                                );
                              }),
                              onChanged: (value) {
                                controller.selectMonth(value!);
                              },
                              decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 200,
                            child: DropdownButtonFormField<int>(
                              value: controller.selectedYear.value,
                              items: List.generate(20, (index) {
                                int year = DateTime.now().year - 4 + index;
                                return DropdownMenuItem(
                                  value: year,
                                  child: Text(year.toString()),
                                );
                              }),
                              onChanged: (value) {
                                controller.selectYear(value!);
                              },
                              decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    actions: [
                      // Gunakan Row untuk menyusun tombol secara horizontal
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceEvenly, // Menyusun tombol secara merata
                        children: [
                          // Tombol Kembali
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.minPositive, 30),
                              backgroundColor:
                                  const Color.fromARGB(255, 235, 0, 43),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () {
                              Get.back(); // Menutup dialog
                            },
                            child: const Text(
                              "Kembali",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Constants
                                    .scaffoldbackgroundColor, // Sesuaikan dengan warna latar belakang
                              ),
                            ),
                          ),

                          // Tombol Export
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.minPositive, 30),
                              backgroundColor: const Color.fromARGB(255, 0, 123,
                                  255), // Ubah warna sesuai keinginan
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () async {
                              await controller.exportToCsv();
                            },
                            child: const Text(
                              "Export",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white, // Sesuaikan warna teks
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(
              Icons.filter_list_rounded,
              size: 30,
              color: Constants
                  .primaryColor, // Sesuaikan dengan warna utama aplikasi Anda
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SearchFormField(
                    hintText: 'Cari Pelanggan',
                    prefixIcon: Icons.search,
                    onChanged: (value) {
                      controller.searchLaporan(value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.filteredLaporanList.length,
                  itemBuilder: (context, index) {
                    var laporan = controller.filteredLaporanList[index];
                    var pelanggan = laporan['pelanggan'];
                    var tanggal = (laporan['tanggal'] as Timestamp).toDate();
                    var formattedDate =
                        DateFormat('dd-MM-yyyy   HH:mm').format(tanggal);
                    var statusPembayaran =
                        laporan['status_pembayaran'] ?? "Belum Lunas";

                    Color backgroundColor = statusPembayaran == "Belum Lunas"
                        ? Constants.fourColor
                        : AppColors.success;

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Order',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    var phoneNumber =
                                        pelanggan['nomor WhatsApp'];
                                    controller.contactViaWhatsApp(phoneNumber);
                                  },
                                  child: SvgPicture.asset(
                                    "assets/images/WhatsappLogo.svg",
                                    width: 25,
                                    height: 25,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            GestureDetector(
                              onTap: () {
                                controller.selectLaporan(laporan);
                                Get.to(() => DetailorderView());
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Nama: ${pelanggan['nama pelanggan']}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Nomor WhatsApp : ${pelanggan['nomor WhatsApp']}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Tanggal: $formattedDate',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
