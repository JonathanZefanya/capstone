import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../component/app_color.dart';
import '../../tambah_pelanggan/views/tambah_pelanggan_view.dart';
import '../../transaksi/controllers/transaksi_controller.dart';
import '../controllers/pelanggan_controller.dart';

class PelangganView extends GetView<PelangganController> {
  const PelangganView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'List Pelanggan',
          style: TextStyle(
            color: Constants.primaryColor,
            fontWeight: FontWeight.w600,
            fontFamily: 'FontPoppins',
            fontSize: 20,
          ),
        ),
        toolbarHeight: 80,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.keyboard_arrow_left_rounded,
            size: 50.0,
            color: Constants.primaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Cari Pelanggan',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      controller.filterPelanggan(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              var pelangganList = controller.filteredPelangganList;
              if (pelangganList.isEmpty) {
                return const Center(
                  child: Text('Tidak ada pelanggan'),
                );
              }
              return ListView.builder(
                itemCount: pelangganList.length,
                itemBuilder: (context, index) {
                  var pelanggan = pelangganList[index];
                  return Card(
                    margin: const EdgeInsets.all(10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(color: Colors.black, width: 1.5),
                    ),
                    color: Colors.white,
                    child: ListTile(
                      title: Text(
                        'Nama : ${pelanggan['nama pelanggan']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            'No WhatsApp: ${pelanggan['nomor WhatsApp']}',
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Alamat : ${pelanggan['alamat'] ?? 'Alamat tidak tersedia'}',
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outlined),
                        onPressed: () {
                          if (pelanggan['id'] != null) {
                            controller.deletePelanggan(pelanggan['id']);
                          } else {
                            Get.snackbar('Error', 'ID pelanggan tidak valid');
                          }
                        },
                      ),
                      onTap: () {
                        Get.find<TransaksiController>()
                            .selectedPelanggan
                            .value = pelanggan;
                        Get.back();
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(77, 62, 147, 50),
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const TambahPelangganView(),
          //   ),
          // );
          
          //URL Navigation /tambah-pelanggan
          Get.toNamed('/tambah-pelanggan');
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}
