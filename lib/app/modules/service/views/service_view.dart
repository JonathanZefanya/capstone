import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/component/search_field.dart';
import '../../../../component/app_color.dart';
import '../../tambah_service/views/tambah_service_view.dart';
import '../../transaksi/controllers/transaksi_controller.dart';
import '../controllers/service_controller.dart';

class ServiceView extends GetView<ServiceController> {
  const ServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    final transaksiController = Get.put(TransaksiController());

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'List service',
            style: TextStyle(
              color: Constants.secondColor,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Express'),
              Tab(text: 'Cuci Lipat'),
              Tab(text: 'Cuci Setrika'),
              Tab(text: 'Cuci Satuan'),
            ],
            onTap: (index) {
              switch (index) {
                case 0:
                  controller.filterserviceByCategory('express');
                  break;
                case 1:
                  controller.filterserviceByCategory('Cuci Lipat');
                  break;
                case 2:
                  controller.filterserviceByCategory('Cuci Strika');
                  break;
                case 3:
                  controller.filterserviceByCategory('satuan');
                  break;
              }
            },
            labelColor: Constants.primaryColor,
            unselectedLabelColor: Colors.grey[600],
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 2,
                color: Constants.primaryColor,
              ),
              insets: EdgeInsets.symmetric(horizontal: 60),
            ),
          ),
          automaticallyImplyLeading: false,
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
        body: TabBarView(
          children: [
            buildserviceList(transaksiController, 'express'),
            buildserviceList(transaksiController, 'Cuci Lipat'),
            buildserviceList(transaksiController, 'Cuci Strika'),
            buildserviceList(transaksiController, 'satuan'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Constants.primaryColor,
          onPressed: () async {
            var result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TambahServiceView(),
              ),
            );
            if (result == true) {
              controller.fetchservice();
            }
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
      ),
    );
  }

  Widget buildserviceList(
      TransaksiController transaksiController, String category) {
    return Obx(() {
      var serviceList = <Map<String, dynamic>>[];
      bool isLoading = controller.isLoading.value;

      switch (category) {
        case 'express':
          serviceList = controller.filteredexpressList.toList();
          break;
        case 'Cuci Lipat':
          serviceList = controller.filteredcuciLipatList.toList();
          break;
        case 'Cuci Strika':
          serviceList = controller.filteredcuciPerjamList.toList();
          break;
        case 'satuan':
          serviceList = controller.filteredsatuanList.toList();
          break;
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SearchFormField(
                    hintText: "Cari Layanan",
                    prefixIcon: Icons.search,
                    onChanged: (value) {
                      controller.searchservice(value, category);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : serviceList.isEmpty
                    ? const Center(
                        child: Text('Tidak ada service'),
                      )
                    : ListView.builder(
                        itemCount: serviceList.length,
                        itemBuilder: (context, index) {
                          var service = serviceList[index];
                          String hargaText;
                          if (service['harga'] != null &&
                              service['harga'] is num) {
                            hargaText =
                                'Rp.${(service['harga'] as num).toStringAsFixed(0)}';
                          } else {
                            hargaText = 'Harga tidak tersedia';
                          }

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: const BorderSide(
                                  color: Constants.borderColor, width: 1.5),
                            ),
                            color: Colors.white,
                            child: ListTile(
                              title: Text(
                                service['nama'] ?? 'Nama tidak tersedia',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                'Harga: $hargaText',
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete_outlined,
                                  color: AppColors.error,
                                ),
                                onPressed: () {
                                  controller.deleteservice(
                                    service['id'],
                                    category,
                                  );
                                },
                              ),
                              onTap: () {
                                if (category == 'express') {
                                  transaksiController.addcuciPerjam(service);
                                } else if (category == 'satuan'){
                                  transaksiController.addSatuan(service);
                                } else {
                                  transaksiController.addService(service);
                                }
                                Get.back();
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      );
    });
  }
}
