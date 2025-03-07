// ignore_for_file: sort_child_properties_last

import 'package:donasi_mobile/controllers/campaign_controller.dart';
import 'package:donasi_mobile/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class CampaignPage extends StatefulWidget {
  const CampaignPage({super.key});

  @override
  State<CampaignPage> createState() => _CampaignPageState();
}

class _CampaignPageState extends State<CampaignPage> {
  final CampaignController homeController = Get.put(CampaignController());

  // Fungsi untuk refresh data
  Future<void> _refresh() async {
    await homeController.fetchCampaigns();
  }

  final GetStorage box = GetStorage();
  String? userRole;

  @override
  void initState() {
    super.initState();
    userRole = box.read('role') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Obx(() {
          if (homeController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: _refresh, // Fungsi yang dipanggil saat refresh
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: homeController.Campaigns.length,
              itemBuilder: (context, index) {
                final data = homeController.Campaigns;
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data[index].title,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          data[index].description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: (data[index].percentage) / 100,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Terkumpul: Rp ${data[index].target_amount} / Rp ${data[index].collected_amount}",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            // Navigasi ke halaman donasi
                            if(userRole == 'donatur') {
                              Get.snackbar("Donatur Page", "Halaman Donatur");
                            } else {
                              Get.snackbar("Admin Page", "Halaman Admin");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text((userRole == 'donatur') ? 'Donasi Sekarang' : 'Detail Campaign', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
      floatingActionButton: userRole == 'relawan'
        ? FloatingActionButton(
            onPressed: () {
              Get.toNamed(AppRoutes.CREATE_CAMPAIGN);
            },
            child: Icon(Icons.add, color: Colors.white),
            backgroundColor: Colors.red,
          )
        : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
