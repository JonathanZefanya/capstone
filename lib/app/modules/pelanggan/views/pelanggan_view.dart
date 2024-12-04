import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/component/search_field.dart';

import '../../../../component/app_color.dart';
import '../../tambah_pelanggan/views/tambah_pelanggan_view.dart';
import '../../transaksi/controllers/transaksi_controller.dart';
import '../controllers/pelanggan_controller.dart';

class PelangganView extends GetView<PelangganController> {
  const PelangganView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'List Pelanggan',
          style: TextStyle(
            color: Constants.secondColor,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        toolbarHeight: 80,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Constants.secondColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SearchFormField(
                    hintText: "Cari Pelanggan",
                    prefixIcon: Icons.search,
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
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(
                          color: Constants.borderColor, width: 1.5),
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
                        icon: const Icon(
                          Icons.delete_outlined,
                          color: AppColors.error,
                        ),
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
        backgroundColor: Constants.primaryColor,
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
