import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../component/app_color.dart';
import '../controllers/tambah_service_controller.dart';

class TambahServiceView extends GetView<TambahServiceController> {
  const TambahServiceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Tambah Produk',
          style: TextStyle(
            color: Constants.primaryColor,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        toolbarHeight: 80,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.keyboard_arrow_left_rounded,
            size: 45,
            color: Constants.primaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Nama Produk",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Constants.primaryColor,
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: controller.namaController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nama Produk',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Obx(() {
                return Column(
                  children: [
                    if (controller.selectedKategori.value != 'cuciSetrika') ...[
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Harga",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Constants.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: controller.hargaController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Harga',
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                            )),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 15),
                    ],
                  ],
                );
              }),
              const Text(
                "Kategori",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Constants.primaryColor,
                ),
              ),
              const SizedBox(height: 5),
              DropdownButtonFormField<String>(
                value: controller.selectedKategori.value,
                onChanged: (value) {
                  controller.selectedKategori.value = value!;
                },
                items: <String>['express', 'cuciLipat', 'cuciSetrika']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Pilih Kategori',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Constants.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  double harga = 0.0;
                  if (controller.selectedKategori.value != 'cuciSetrika') {
                    harga =
                        double.tryParse(controller.hargaController.text) ?? 0.0;
                  }
                  controller.tambahProduk(
                    controller.namaController.text,
                    harga,
                    controller.selectedKategori.value,
                  );
                },
                child: const Text(
                  'Simpan',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
