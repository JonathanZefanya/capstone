import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailorderController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> saveInvoiceAsImage() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      screenshotController.capture().then((Uint8List? image) async {
        if (image != null) {
          final result = await ImageGallerySaver.saveImage(
              Uint8List.fromList(image),
              quality: 60,
              name: "invoice-${DateTime.now().toIso8601String()}.png");
          Get.snackbar("Success", "Invoice saved to gallery!");
        }
      }).catchError((onError) {
        Get.snackbar("Error", "Failed to save invoice: $onError");
      });
    } else {
      Get.snackbar("Permission Denied",
          "Storage permission is required to save images.");
    }
  }

  Future<void> saveInvoiceAndSendWhatsApp(
      String phoneNumber, String message) async {
    // Meminta izin untuk mengakses penyimpanan penuh di Android 11 ke atas
    final status = await Permission.manageExternalStorage.request();

    // Jika izin diberikan
    if (status.isGranted) {
      // Jika izin disetujui, lanjutkan dengan proses penyimpanan dan pengambilan screenshot
      screenshotController.capture().then((Uint8List? image) async {
        if (image != null) {
          // Simpan gambar ke galeri
          final result = await ImageGallerySaver.saveImage(
            Uint8List.fromList(image),
            quality: 60,
            name: "invoice-${DateTime.now().millisecondsSinceEpoch}.png",
          );

          if (result['isSuccess'] == true) {
            Get.snackbar("Success", "Invoice saved to gallery!");

            // Simpan gambar ke direktori sementara
            final tempDir = await getTemporaryDirectory();
            final file = File('${tempDir.path}/invoice.png');
            await file.writeAsBytes(image);

            // Kirim WhatsApp dengan gambar terlampir
            final whatsappUrl =
                'https://api.whatsapp.com/send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}';

            if (await canLaunch(whatsappUrl)) {
              await launch(whatsappUrl);
            } else {
              Get.snackbar("Error", "Could not open WhatsApp");
            }
          } else {
            Get.snackbar("Error", "Failed to save invoice");
          }
        } else {
          Get.snackbar("Error", "Failed to capture screenshot");
        }
      }).catchError((onError) {
        Get.snackbar("Error", "Failed to capture screenshot: $onError");
      });
    } else {
      // Jika izin tidak diberikan, tampilkan notifikasi untuk meminta izin
      Get.snackbar("Permission Denied",
          "Please grant storage permission from settings.");
      // Buka pengaturan aplikasi untuk meminta izin secara manual
      openAppSettings();
    }
  }
}
