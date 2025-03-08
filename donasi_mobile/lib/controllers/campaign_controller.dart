import 'package:donasi_mobile/models/campaign_model.dart';
import 'package:donasi_mobile/routes/app_pages.dart';
import 'package:flutter/material.dart';
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
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));

    final box = GetStorage();
    try {
      String? token = box.read('token');
      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.campaign}');
      final headers = {
        'Authorization': 'Bearer $token',
        "Content-Type": "application/json"
      };

      final response = await http.post(
        Uri.parse("$uri"),
        headers: headers,
        body: json.encode({
          "title": title,
          "description": description,
          "target_amount": targetAmount,
          "collected_amount": 0,
          "deadline": deadline,
          "status": "open", 
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success", 
          "Campaign berhasil dibuat!",
          backgroundColor: Colors.green,
          colorText: Colors.white, // Agar teks tetap terlihat jelas
          snackPosition: SnackPosition.BOTTOM, // Bisa diubah ke TOP jika ingin di atas
        );

        Future.delayed(Duration(milliseconds: 1000), () {
          Get.toNamed(AppRoutes.HOME);
        });
      } else {
        Get.snackbar("Error", "Gagal membuat campaign");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDetailCampaigns(String id) async {
    final box = GetStorage();
    String? token = box.read('token');
    final headers = {
      'Authorization': 'Bearer $token',
    };
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.campaignDetail}/${id.toString()}');
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData["data"] is List) {
          List<dynamic> data = jsonData["data"];
          Campaigns.assignAll(data.map((e) => Campaign.fromJson(e)).toList());
        } else if (jsonData["data"] is Map) {
          Campaign campaign = Campaign.fromJson(jsonData["data"]);
          Campaigns.assignAll([campaign]);
        } else {
          Campaigns.assignAll([]);
        }
      } else {
        Get.snackbar("Error", "Gagal mengambil data campaign");
      }
    } catch(e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e");
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
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    } finally {
      isLoading(false);
    }
  }
}