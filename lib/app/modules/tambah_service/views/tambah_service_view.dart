import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../component/app_color.dart';
import '../controllers/tambah_service_controller.dart';

class TambahServiceView extends GetView<TambahServiceController> {
  const TambahServiceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TambahServiceController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Tambah Service',
          style: TextStyle(
            color: Constants.secondColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        toolbarHeight: 80,
       leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Constants.secondColor,
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
                "Nama Service",
                style: TextStyle(
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
                  hintText: 'Nama Service',
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Harga /Kg",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Constants.primaryColor,
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: controller.hargaController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Harga',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              const Text(
                "Kategori",
                style: TextStyle(
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
                  controller.tambahProduk(
                    controller.namaController.text,
                    double.tryParse(controller.hargaController.text) ?? 0.0,
                    controller.selectedKategori.value,
                  );
                  Get.back();
                },
                child: const Text(
                  'Simpan',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
