import 'package:get/get.dart';

import '../controllers/edittransaksi_controller.dart';

class EdittransaksiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditTransaksiController>(
      () => EditTransaksiController(),
    );
  }
}
