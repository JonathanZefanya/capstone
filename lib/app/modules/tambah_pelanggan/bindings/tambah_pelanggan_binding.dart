import 'package:get/get.dart';

import '../controllers/tambah_pelanggan_controller.dart';

class TambahPelangganBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TambahPelangganController>(
      () => TambahPelangganController(),
    );
  }
}
