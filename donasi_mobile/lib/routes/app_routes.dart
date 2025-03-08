import 'package:donasi_mobile/routes/app_pages.dart';
import 'package:donasi_mobile/views/campaign/create.dart';
import 'package:donasi_mobile/views/campaign/detail.dart';
import 'package:get/get.dart';
import '../views/login_view.dart';
import '../views/home_view.dart';

import '../bindings/auth_binding.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeView(),
    ),
    GetPage(
      name: AppRoutes.CREATE_CAMPAIGN, 
      page: () => CreateCampaignView()
    ),
    GetPage(
      name: AppRoutes.DETAIL_CAMPAIGN, 
      page: () => DetailDonasiPage()
    ),
  ];
}
