import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constant.dart';
import 'package:get_storage/get_storage.dart';

class CampaignController extends GetxController {
  var isLoading = true.obs;
  var campaigns = [].obs;

  @override
  void onInit() {
    fetchCampaigns();
    super.onInit();
  }

  Future<void> fetchCampaigns() async {
    final box = GetStorage();

    try {
      isLoading(true);
      String? token = box.read('token');

      final headers = {
        'Authorization': 'Bearer $token',
      };

      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.campaign}');

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        campaigns.value = data["data"];
      } else {
        Get.snackbar("Error", "Gagal mengambil data campaign");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    } finally {
      isLoading(false);
    }
  }
}