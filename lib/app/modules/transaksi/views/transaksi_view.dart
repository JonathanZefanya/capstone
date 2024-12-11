import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/service/controllers/service_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';

import '../../../../component/app_color.dart';
import '../../../../component/nointernet_widget.dart';
import '../../service/views/service_view.dart';
import '../controllers/transaksi_controller.dart';

class TransaksiView extends GetView<TransaksiController> {
  const TransaksiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.scaffoldbackgroundColor,
        title: const Text(
          'Transaksi',
          style: TextStyle(
            color: Constants.secondColor,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        toolbarHeight: 80,
        leading: IconButton(
          onPressed: () {
            Get.offAllNamed(Routes.HOME);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Constants.secondColor,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<bool>(
          future: controller.checkInternetConnection(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData && snapshot.data == true) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.minPositive, 35),
                              backgroundColor: AppColors.accent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              Get.toNamed('/pelanggan');
                            },
                            child: const Text(
                              "Pelanggan",
                              style: TextStyle(
                                color: Constants.scaffoldbackgroundColor,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.minPositive, 35),
                              backgroundColor: Constants.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              Get.to(() => const ServiceView());
                              Get.put(ServiceController());
                            },
                            child: const Text(
                              "Service",
                              style: TextStyle(
                                color: Constants.scaffoldbackgroundColor,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Obx(() {
                            var pelanggan = controller.selectedPelanggan.value;
                            if (pelanggan.isNotEmpty) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Card(
                                    elevation: 0,
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Nama : ${pelanggan['nama pelanggan']}",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                "Nomor : ${pelanggan['nomor WhatsApp']}",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                "Alamat : ${pelanggan['alamat']}",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                softWrap: true,
                                                overflow: TextOverflow
                                                    .visible,
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            controller.selectPelanggan({});
                                          },
                                          icon: const Icon(
                                            Icons.delete_outlined,
                                            color: Constants.primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(color: Constants.primaryColor),
                                ],
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }),
                          Obx(() {
                            var cuciPerjamList = controller.selectedcuciPerjam;
                            if (cuciPerjamList.isNotEmpty) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5),
                                  const Card(
                                    elevation: 0,
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Text(
                                      "Laundry Perjam:",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Column(
                                    children: List.generate(
                                        cuciPerjamList.length, (index) {
                                      var cuciPerjam = cuciPerjamList[index];
                                      return Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "${cuciPerjam['nama']}\nRp.${cuciPerjam['harga'].toStringAsFixed(0)}",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 50,
                                                    height: 30,
                                                    child: TextFormField(
                                                      initialValue: cuciPerjam[
                                                                  'berat'] !=
                                                              null
                                                          ? cuciPerjam['berat']
                                                              .toString()
                                                          : '1',
                                                      keyboardType:
                                                          const TextInputType
                                                              .numberWithOptions(
                                                              decimal: true),
                                                      textAlign:
                                                          TextAlign.center,
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                      ),
                                                      onChanged: (value) {
                                                        if (value.isNotEmpty) {
                                                          controller
                                                              .updateBeratcuciPerjam(
                                                            index,
                                                            double.parse(value)
                                                                .toDouble(),
                                                          );
                                                        } else {
                                                          controller
                                                              .updateBeratcuciPerjam(
                                                                  index, 1);
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  const Text(
                                                    "Kg",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      controller
                                                          .removecuciPerjam(
                                                              index);
                                                    },
                                                    icon: const Icon(
                                                      Icons.delete_outlined,
                                                      color: Constants
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const Divider(
                                              color: Constants.primaryColor),
                                        ],
                                      );
                                    }),
                                  ),
                                ],
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }),
                          Obx(
                            () {
                              var ServiceList = controller.selectedService;
                              if (ServiceList.isNotEmpty) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5),
                                    Card(
                                      elevation: 0,
                                      color: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Laundry Harian:",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Card(
                                      elevation: 0,
                                      color: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: List.generate(
                                          ServiceList.length,
                                          (index) {
                                            var Service = ServiceList[index];
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Menampilkan kategori di atas harga
                                                Text(
                                                  "${Service['kategori']}",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "${Service['nama']}\nRp.${Service['harga'].toStringAsFixed(0)}",
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 50,
                                                          height: 30,
                                                          child: TextFormField(
                                                            initialValue: Service[
                                                                        'jumlah'] !=
                                                                    null
                                                                ? Service[
                                                                        'jumlah']
                                                                    .toString()
                                                                : '1',
                                                            keyboardType:
                                                                const TextInputType
                                                                    .numberWithOptions(
                                                                    decimal:
                                                                        true),
                                                            textAlign: TextAlign
                                                                .center,
                                                            decoration:
                                                                const InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(),
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                            ),
                                                            onChanged: (value) {
                                                              if (value
                                                                  .isNotEmpty) {
                                                                controller
                                                                    .updateJumlahService(
                                                                  index,
                                                                  double.parse(
                                                                          value)
                                                                      .toDouble(),
                                                                );
                                                              } else {
                                                                controller
                                                                    .updateJumlahService(
                                                                  index,
                                                                  1,
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        const Text(
                                                          "Kg",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: () {
                                                            controller
                                                                .removeService(
                                                                    index);
                                                          },
                                                          icon: const Icon(
                                                            Icons
                                                                .delete_outlined,
                                                            color: Constants
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                          // Obx khusus untuk service satuan
                          // To-Do: Tambahkan Obx untuk menampilkan service satuan
                          Obx(
                            () {
                              var satuanList = controller.selectedSatuan;
                              if (satuanList.isNotEmpty) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5),
                                    Card(
                                      elevation: 0,
                                      color: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Laundry Satuan:",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Card(
                                      elevation: 0,
                                      color: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: List.generate(
                                          satuanList.length,
                                          (index) {
                                            var satuan = satuanList[index];
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Menampilkan kategori di atas harga
                                                Text(
                                                  "${satuan['kategori']}",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "${satuan['nama']}\nRp.${satuan['harga'].toStringAsFixed(0)}",
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 50,
                                                          height: 30,
                                                          child: TextFormField(
                                                            initialValue: satuan[
                                                                        'jumlah'] !=
                                                                    null
                                                                ? satuan[
                                                                        'jumlah']
                                                                    .toString()
                                                                : '1',
                                                            keyboardType:
                                                                const TextInputType
                                                                    .numberWithOptions(
                                                              decimal: true,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                            decoration:
                                                                const InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(),
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                            ),
                                                            onChanged: (value) {
                                                              if (value
                                                                  .isNotEmpty) {
                                                                controller
                                                                    .updateJumlahSatuan(
                                                                  index,
                                                                  double.parse(
                                                                          value)
                                                                      .toDouble(),
                                                                );
                                                              } else {
                                                                controller
                                                                    .updateJumlahSatuan(
                                                                  index,
                                                                  1,
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        const Text(
                                                          "Pcs",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: () {
                                                            controller
                                                                .removeSatuan(
                                                                    index);
                                                          },
                                                          icon: const Icon(
                                                            Icons
                                                                .delete_outlined,
                                                            color: Constants
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          ),

                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Metode Bayar",
                                style: TextStyle(
                                  color: Constants.primaryColor,
                                ),
                              ),
                              DropdownButtonFormField<String>(
                                value: controller.metodePembayaran.value,
                                onChanged: (newValue) {
                                  controller.metodePembayaran.value = newValue!;
                                },
                                items: <String>[
                                  'Bayar Nanti',
                                  'Cash',
                                  'QRIS',
                                  'Transfer',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                ),
                              ),
                              Obx(() {
                                if (controller.metodePembayaran.value ==
                                    'QRIS') {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: Image.asset(
                                      'assets/images/qris-logo.jpg', // Pastikan gambar QRIS ada di folder assets
                                      width: double
                                          .infinity, // Atur ukuran gambar sesuai kebutuhan
                                      height: 200,
                                    ),
                                  );
                                } else {
                                  return const SizedBox
                                      .shrink(); // Tidak menampilkan gambar jika bukan QRIS
                                }
                              }),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Status Bayar",
                                style: TextStyle(
                                  color: Constants.primaryColor,
                                ),
                              ),
                              DropdownButtonFormField<String>(
                                value: controller.statusPembayaran.value,
                                onChanged: (newValue) {
                                  controller.statusPembayaran.value = newValue!;
                                },
                                items: <String>[
                                  'Lunas',
                                  'Belum Lunas',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Status Pesanan",
                                style: TextStyle(
                                  color: Constants.primaryColor,
                                ),
                              ),
                              DropdownButtonFormField<String>(
                                value: controller.statusPengambilan.value,
                                onChanged: (newValue) {
                                  controller.statusPengambilan.value =
                                      newValue!;
                                },
                                items: <String>[
                                  'Belum Di Ambil',
                                  'Ambil Sendiri',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(() => Text(
                          "Total: Rp.${controller.totalHarga.value.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Constants.secondColor,
                          ),
                        )),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 45),
                        backgroundColor: Constants.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        // Jika pelanggan kosong dan service kosong maka akan muncul dialog data tidak lengkap
                        if (controller.selectedPelanggan.value.isEmpty) {
                          Get.defaultDialog(
                            title: "Data tidak lengkap",
                            middleText: "Pelanggan harus diisi",
                            textConfirm: "OK",
                            confirmTextColor: Constants.scaffoldbackgroundColor,
                            onConfirm: () {
                              Get.back();
                            },
                          );
                        } else if (controller.selectedService.isEmpty &&
                            controller.selectedcuciPerjam.isEmpty &&
                            controller.selectedSatuan.isEmpty) {
                          Get.defaultDialog(
                            title: "Data tidak lengkap",
                            middleText: "service harus diisi",
                            textConfirm: "OK",
                            confirmTextColor: Constants.scaffoldbackgroundColor,
                            onConfirm: () {
                              Get.back();
                            },
                          );
                        } else {
                          controller.saveTransaksi();
                        }
                        // controller.saveTransaksi();
                      },
                      child: const Text(
                        "Simpan",
                        style: TextStyle(
                          color: Constants.scaffoldbackgroundColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            } else {
              // Tidak ada koneksi internet
              return const NoInternet();
            }
          }),
    );
  }
}
