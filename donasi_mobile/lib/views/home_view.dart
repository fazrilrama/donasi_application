// ignore_for_file: library_private_types_in_public_api

import 'package:donasi_mobile/views/campaign.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/campaign_controller.dart';
import 'package:get_storage/get_storage.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0; // Index aktif di BottomNavigationBar

  final List<Widget> _pages = [
    CampaignPage(),
    Text('hehe'),
    Text('hehe'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text("Donasi Yuk"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.red), // Ganti ikon logout
            onPressed: () {
              Get.defaultDialog(
                title: "Konfirmasi",
                middleText: "Apakah Anda yakin ingin logout?",
                textConfirm: "Ya",
                textCancel: "Batal",
                confirmTextColor: Colors.white,
                buttonColor: Colors.red,
                onConfirm: () {
                  final box = GetStorage();
                  box.erase(); // Hapus data login
                  Get.offAllNamed('/login'); // Redirect ke halaman login
                },
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Donasi",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}