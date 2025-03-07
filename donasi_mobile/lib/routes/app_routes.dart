import 'package:donasi_mobile/routes/app_pages.dart';
import 'package:donasi_mobile/views/campaign/create.dart';
import 'package:get/get.dart';
import '../views/login_view.dart';
import '../views/home_view.dart';
import '../views/campaign_detail_view.dart';
import '../views/donation_view.dart';

import '../bindings/auth_binding.dart';
import '../bindings/campaign_binding.dart';
import '../bindings/donation_binding.dart';

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
    // GetPage(
    //   name: AppRoutes.CAMPAIGN_DETAIL,
    //   page: () => CampaignDetailView(),
    //   binding: CampaignBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.DONATION,
    //   page: () => DonationView(),
    //   binding: DonationBinding(),
    // ),
  ];
}
