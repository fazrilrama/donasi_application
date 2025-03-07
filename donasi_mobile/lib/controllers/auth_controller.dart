import 'dart:convert';
import 'package:donasi_mobile/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../models/user_model.dart';
import '../routes/app_routes.dart';
import '../utils/constant.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var user = Rxn<User>();
  final box = GetStorage(); // 🔥 Storage untuk simpan token & name

  Future<void> login(String email, String password) async {
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 2));

    try {

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        
        // 🔥 Simpan token & name ke storage
        box.write("isLoggedIn", true);
        box.write("token", data['token']);
        box.write("name", data['user']['name']);
        box.write("role", data['user']['role']);

        // 🔥 Simpan ke state user
        user.value = User(
          id: data['user']['id'],
          name: data['user']['name'],
          email: data['user']['email'],
          role: data['user']['role'],
        );

        Get.offAllNamed(AppRoutes.HOME);
      } else {
        Get.snackbar("Login Gagal", "Email atau password salah");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    user.value = null;
    box.remove("token"); // 🔥 Hapus token
    box.remove("name");  // 🔥 Hapus nama
    Get.offAllNamed(AppRoutes.LOGIN);
  }
}