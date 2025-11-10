import 'dart:async'; // Timer Countdown
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Carousel Slider
import 'package:http/http.dart' as http; // ambil data API JSON
import 'dart:convert'; // Decode JSON
import 'package:geolocator/geolocator.dart'; // GPS
import 'package:geocoding/geocoding.dart'; // Konversi GPS
import 'package:intl/intl.dart'; // Formatter Number
import 'package:permission_handler/permission_handler.dart'; // Izin Handler
import 'package:shared_preferences/shared_preferences.dart'; // Cache Lokal
import 'package:string_similarity/string_similarity.dart'; // Fuzzy Match String

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CarouselController _controller = CarouselController();
  int _currentIndex = 0;

  final posterList = const <String>[
    'assets/images/ramadhan_kareem.png',
    'assets/images/idl_fitr.png',
    'assets/images/idl_adh.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            // ======================================
            // Menu Section
            // =====================================

            _buildMenuGridSection(),

            // ======================================
            // Carousel Section
            // =====================================
            _buildCarouselSelection(),
          ],
        ),
      ),
    );
  }

// ignore: slash_for_doc_comments
/**
 * ============================
 * Menu Item Widget
 * ============================
 */

Widget _buildMenuItem(
  String iconPath,
  String title,
  String routeName,
  ) {
  return InkWell(
    onTap: () {
      
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(12), 
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), 
          blurRadius: 4,
          offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(iconPath, width: 35,),
          const SizedBox(height: 6,),
          Text(title, style:
          TextStyle(
            fontFamily: 'PoppinsRegular',),)
        ],
      ),
    ),
  );
}

// ignore: slash_for_doc_comments
/**
 * ============================
 * Menu Grid Section Widget
 * ============================
 */

Widget _buildMenuGridSection() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildMenuItem(
          'assets/images/ic_menu_doa.png', // IconPath
          'Doa Harian', // Title
          '/doa', // RouteName
          ),

        _buildMenuItem(
          'assets/images/ic_menu_jadwal_sholat.png', // IconPath
          'Jadwal Sholat', // Title
          '/sholat', // RouteName
          ),
          
        _buildMenuItem(
          'assets/images/ic_menu_video_kajian.png', // IconPath
          'Video Kajian', // Title
          '/kajian', // RouteName
          ),

        _buildMenuItem(
          'assets/images/ic_menu_zakat.png', // IconPath
          'Zakat', // Title
          '/zakat', // RouteName
          ),

      ],
      ),
  );
  }

// ignore: slash_for_doc_comments
/**
 * ============================
 * Carousel Section
 * ============================
 */


  Widget _buildCarouselSelection() {
    return Column(
      children: [
        const SizedBox(height: 20),

        // Carousel Card
        CarouselSlider.builder(
          itemCount: posterList.length,
          itemBuilder: (context, index, realIndex) {
            final poster = posterList[index];
            return Container(
              margin: EdgeInsets.all(15),
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(20),
                child: Image.asset(
                  poster,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
          options: CarouselOptions(
            autoPlay: true,
            height: 270,
            enlargeCenterPage: true,
            viewportFraction: 0.7,
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
        ),

        // Dot Indikator Carousel
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: posterList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _currentIndex.animateToPage(entry.key),
              child: Container(
                width: 10,
                height: 10,
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == entry.key ? Colors.amber : Colors.grey[400],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

extension on int {
  void animateToPage(int key) {}
}

