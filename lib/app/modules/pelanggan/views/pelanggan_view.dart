import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/pelanggan_controller.dart';

class PelangganView extends GetView<PelangganController> {
  const PelangganView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PelangganView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PelangganView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
