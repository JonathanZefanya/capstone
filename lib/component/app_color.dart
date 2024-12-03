import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF007AFF); // Biru
  static const Color accent = Color(0xFFFFC107); // Kuning
  static const Color grey = Color(0xFF9E9E9E); // Abu-abu
  static const Color greyLight = Color(0xFFEEEEEE); // Abu-abu terang
  static const Color greyDark = Color(0xFF616161); // Abu-abu gelap
  static const Color error = Color(0xFFF44336); // Merah
  static const Color success = Color(0xFF4CAF50); // Hijau untuk sukses
  static const Color warning = Color(0xFFFF9800); // Oranye untuk peringatan
}

class Constants {
  static const Color primaryColor = Color(0xFF007AFF); // Biru tua
  static const Color secondColor = Color(0xff646C83); // Biru muda
  static const Color thirdColor = Color(0xff128864); // Hijau
  static const Color fourColor = Color(0xff933E4D); // Merah
  static const Color borderColor = Color.fromARGB(255, 209, 209, 209); // Merah
  static const Color fiveColor = Color(0xff797979); // Abu-abu
  static const Color scaffoldbackgroundColor =
      Color.fromRGBO(245, 247, 249, 1); // Warna background scaffold
  static const Color menucolor = Color(0xffF0F0F0);

  static var errorColor; // Warna background menu
}

const LinearGradient primaryGradient = LinearGradient(
    colors: [Color.fromARGB(255, 109, 230, 90), Color.fromARGB(255, 86, 233, 111)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter);

const Color blueColor = Color(0xFF5680E9);
const Color yellowColor = Color(0xFFFFE45E);
const Color blue2Color = Color(0xFF63B1EF);
const Color blue3Color = Color(0xFFCBD6F3);
const Color whiteColor = Color(0xFFFFFFFF);
const Color greyColor = Color(0xFF878F95);

const FontWeight weightBold = FontWeight.bold;
const FontWeight weightNormal = FontWeight.normal;
const FontWeight weightMedium = FontWeight.w500;
const FontWeight weightSemiBold = FontWeight.w600;
const FontWeight weightLight = FontWeight.w300;
