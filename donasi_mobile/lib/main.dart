// ignore_for_file: annotate_overrides

import 'package:donasi_mobile/controllers/auth_controller.dart';
import 'package:donasi_mobile/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

void checkLoginStatus() {
  final box = GetStorage();
  bool isLoggedIn = box.read("isLoggedIn") ?? false;

  if (isLoggedIn) {
    Get.offAllNamed(AppRoutes.HOME); // Jika sudah login, langsung ke home
  } else {
    Get.offAllNamed(AppRoutes.LOGIN); // Jika belum login, ke login page
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AuthController());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1000), () {
      checkLoginStatus(); // Tunggu sebentar sebelum cek login
    });
  }
  
  @override
  Widget build(BuildContext context) {
    
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: CircularProgressIndicator())), // Loading sementara
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(), // Semua teks otomatis pakai Poppins
      ),
      getPages: AppPages.routes,
    );
  }
}
