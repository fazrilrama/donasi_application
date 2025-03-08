// ignore_for_file: use_key_in_widget_constructors, unnecessary_null_comparison, sized_box_for_whitespace, invalid_use_of_protected_member

import 'package:donasi_mobile/controllers/campaign_controller.dart';
import 'package:donasi_mobile/utils/constant.dart';
import 'package:donasi_mobile/widgets/fullscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailDonasiPage extends StatefulWidget {
  @override
  State<DetailDonasiPage> createState() => _DetailDonasiPageState();
}

class _DetailDonasiPageState extends State<DetailDonasiPage> {
  final String? campaignId = Get.parameters['id'];
  final CampaignController campaignController = Get.put(CampaignController());

  @override
  void initState() {
    super.initState();
    if (campaignId != null) {
      campaignController.fetchDetailCampaigns(campaignId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Campaign", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
      body: Obx(() {
        final campaign = campaignController.Campaigns.value;
        if (campaign == null) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Gambar Header
              Container(
                width: double.infinity,
                height: 200,
                child: GestureDetector(
                  onTap: () {
                    final images = campaign[0].images ?? [];
                    if (images.isEmpty) return; // Jika tidak ada gambar, tidak lakukan apa-apa

                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          backgroundColor: Colors.transparent,
                          child: Container(
                            width: double.infinity,
                            height: 400,
                            child: PageView.builder(
                              itemCount: images.length,
                              itemBuilder: (context, index) {
                                return Image.network(
                                  "${ApiConstants.fileUrlCampaign}${images[index]['name']}", // 🔹 Ambil gambar sesuai index
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.broken_image, size: 50, color: Colors.grey);
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    child: (campaign[0].images != null && campaign[0].images!.isNotEmpty)
                        ? PageView.builder( // 🔹 Ubah jadi slider di tampilan utama
                            itemCount: campaign[0].images!.length,
                            itemBuilder: (context, index) {
                              return Image.network(
                                "${ApiConstants.fileUrlCampaign}${campaign[0].images![index]['name']}",
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.broken_image, size: 50, color: Colors.grey);
                                },
                              );
                            },
                          )
                        : Image.network(
                            "https://picsum.photos/800/500",
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),




              // 🔹 Card untuk informasi donasi
              Padding(
                padding: EdgeInsets.all(16),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(campaign[0].title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text("Sampai : ${campaign[0].deadline}", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.red)),
                        
                        SizedBox(height: 8),
                        Text("Terkumpul :", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.red)),
                        SizedBox(height: 8),
                        Text("Rp ${campaign[0].collected_amount} dari Rp ${campaign[0].target_amount}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
                        SizedBox(height: 15),
                        LinearProgressIndicator(
                          value: campaign[0].percentage / 100,
                          backgroundColor: Colors.grey[300],
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  campaign[0].description,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      }),

      // 🔹 Tombol Tetap di Bawah
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("Tanya Penjual", style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  side: BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("Request Survey", style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
