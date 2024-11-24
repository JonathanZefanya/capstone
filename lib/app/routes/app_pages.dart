import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/laporan/bindings/laporan_binding.dart';
import '../modules/laporan/views/laporan_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/pelanggan/bindings/pelanggan_binding.dart';
import '../modules/pelanggan/views/pelanggan_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/service/bindings/service_binding.dart';
import '../modules/service/views/service_view.dart';
import '../modules/tambah_service/bindings/tambah_service_binding.dart';
import '../modules/tambah_service/views/tambah_service_view.dart';
import '../modules/transaksi/bindings/transaksi_binding.dart';
import '../modules/transaksi/views/transaksi_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;
  static const LOGIN = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SERVICE,
      page: () => const ServiceView(),
      binding: ServiceBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.PELANGGAN,
      page: () => const PelangganView(),
      binding: PelangganBinding(),
    ),
    GetPage(
      name: _Paths.LAPORAN,
      page: () => const LaporanView(),
      binding: LaporanBinding(),
    ),
    GetPage(
      name: _Paths.TRANSAKSI,
      page: () => const TransaksiView(),
      binding: TransaksiBinding(),
    ),
    GetPage(
      name: _Paths.TAMBAH_SERVICE,
      page: () => const TambahServiceView(),
      binding: TambahServiceBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
  ];
}
