import 'package:donasi_mobile/models/campaign_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constant.dart';
import 'package:get_storage/get_storage.dart';

class CampaignController extends GetxController {
  var isLoading = true.obs;
  var Campaigns = <Campaign>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCampaigns();
  }

  Future<void> createCampaign(String title, String description, double targetAmount, String deadline) async {
    try {
      isLoading(true);
      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.campaign}');

      final response = await http.post(
        Uri.parse("$uri"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "title": title,
          "description": description,
          "target_amount": targetAmount,
          "collected_amount": 0, // Default ke 0
          "deadline": deadline,
          "status": "open", // Default "open"
        }),
      );

      if (response.statusCode == 201) {
        Get.snackbar("Success", "Campaign berhasil dibuat!");
        Get.back(); // Kembali ke halaman sebelumnya
      } else {
        Get.snackbar("Error", "Gagal membuat campaign");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    } finally {
      isLoading(false);
    }
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
        final jsonData = json.decode(response.body);
        List<dynamic> data = jsonData["data"];
        Campaigns.assignAll(data.map((e) => Campaign.fromJson(e)).toList());
      } else {
        Get.snackbar("Error", "Gagal mengambil data campaign");
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    } finally {
      isLoading(false);
    }
  }
}