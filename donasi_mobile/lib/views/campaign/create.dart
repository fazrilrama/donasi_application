// ignore_for_file: unused_import, depend_on_referenced_packages, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/campaign_controller.dart';

class CreateCampaignView extends StatelessWidget {
  final CampaignController campaignController = Get.put(CampaignController());
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController targetAmountController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buat Campaign", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.red.shade700,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade700, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 10,
              color: Colors.white,
              shadowColor: Colors.black.withOpacity(0.2),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Detail Campaign", 
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.red.shade700)
                    ),
                    SizedBox(height: 10),
                    _buildTextField(context, titleController, "Judul Campaign", Icons.title),
                    _buildTextField(context, descriptionController, "Deskripsi", Icons.description, maxLines: 3),
                    _buildTextField(context, targetAmountController, "Target Donasi (Rp)", Icons.attach_money, keyboardType: TextInputType.number),
                    _buildTextField(context, deadlineController, "Tenggat Waktu", Icons.date_range, keyboardType: TextInputType.none), // Pakai date picker

                    SizedBox(height: 20),
                    Obx(() => SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: campaignController.isLoading.value
                                ? null
                                : () {
                                    campaignController.createCampaign(
                                      titleController.text,
                                      descriptionController.text,
                                      double.tryParse(targetAmountController.text) ?? 0,
                                      deadlineController.text,
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: campaignController.isLoading.value
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    "Buat Campaign",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                                  ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk input field dengan ikon
  Widget _buildTextField(
    BuildContext context, // Tambahkan context di sini
    TextEditingController controller, String label, IconData icon,
    {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {

    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        readOnly: label == "Tenggat Waktu", // Hanya baca jika label Tenggat Waktu
        onTap: label == "Tenggat Waktu"
            ? () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context, // Gunakan context dari parameter
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null) {
                  controller.text = "${pickedDate.toLocal()}".split(' ')[0]; // Format YYYY-MM-DD
                }
              }
            : null, // Tidak melakukan apa-apa untuk input lainnya
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 14, color: Colors.red.shade700),
          prefixIcon: Icon(icon, color: Colors.red.shade700),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade700, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

}
