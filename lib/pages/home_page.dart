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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(),
                            child: Column(
                              children: [
                                Image.asset('assets/images/ic_menu_doa.png'),
                                Text(
                                  'Doa & Dzikir',
                                  style: TextStyle(
                                    fontFamily: 'PoppinsRegular',
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(),
                            child: Column(
                              children: [
                                Image.asset('assets/images/ic_menu_zakat.png'),
                                Text(
                                  'Zakat',
                                  style: TextStyle(
                                    fontFamily: 'PoppinsRegular',
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/ic_menu_jadwal_sholat.png',
                                ),
                                Text(
                                  'Jadwal Sholat',
                                  style: TextStyle(
                                    fontFamily: 'PoppinsRegular',
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/ic_menu_video_kajian.png',
                                ),
                                Text(
                                  'Video Kajian',
                                  style: TextStyle(
                                    fontFamily: 'PoppinsRegular',
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ======================================
            // Carousel Section
            // =====================================
            _buildCarouselSelection(),
          ],
        ),
      ),
    );
  }

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

