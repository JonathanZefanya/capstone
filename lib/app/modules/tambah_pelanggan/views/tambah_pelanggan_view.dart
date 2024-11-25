import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../component/app_color.dart';
import '../controllers/tambah_pelanggan_controller.dart';

class TambahPelangganView extends GetView<TambahPelangganController> {
  const TambahPelangganView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Tambah Pelanggan',
          style: TextStyle(
            color: Constants.primaryColor,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        toolbarHeight: 80,
        leading: IconButton(
          onPressed: () {
            Get.back();
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
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Nama Pelanggan",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Constants.primaryColor,
                  fontFamily: 'Poppins',
                ),
              ),
              TextField(
                controller: controller.namaPelangganController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nama Pelanggan',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Nomor WhatsApp",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Constants.primaryColor,
                  fontFamily: 'Poppins',
                ),
              ),
              Row(
                children: [
                  Obx(() => DropdownButton<String>(
                        value: controller.selectedCountryCode.value,
                        items: controller.countryCodes
                            .map((code) => DropdownMenuItem(
                                  value: code,
                                  child: Text(code),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedCountryCode.value = value;
                          }
                        },
                      )),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: controller.nomorWhatsAppController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(12),
                      ],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Nomor WhatsApp',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "Alamat",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Constants.primaryColor,
                  fontFamily: 'Poppins',
                ),
              ),
              TextField(
                controller: controller.alamatController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Alamat',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Constants.primaryColor,
                      padding: const EdgeInsets.all(10)),
                  onPressed: () {
                    controller.tambahPelanggan(
                        controller.namaPelangganController.text,
                        controller.nomorWhatsAppController.text,
                        controller.alamatController.text);
                  },
                  child: const Text(
                    "Simpan",
                    style: TextStyle(
                      color: Constants.scaffoldbackgroundColor,
                      fontFamily: 'Poppins',
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
