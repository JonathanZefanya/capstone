import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/transaksi_controller.dart';

class TransaksiView extends GetView<TransaksiController> {
  const TransaksiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TransaksiView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TransaksiView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
