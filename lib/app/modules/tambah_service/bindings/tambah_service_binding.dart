import 'package:get/get.dart';

import '../controllers/tambah_service_controller.dart';

class TambahServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TambahServiceController>(
      () => TambahServiceController(),
    );
  }
}
