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
  bool _isLoading = true;
  Duration? _timeRemaining;
  Timer? _countdownTimer;
  String _location = "Mengambil Lokasi....";
  String _prayTime = "Loading...";
  String _backgroundImage = 'assets/images/bg_morning.png';
  List<dynamic>? _jadwalSholat;
  
  final posterList = const <String>[
    'assets/images/ramadhan_kareem.png',
    'assets/images/idl_fitr.png',
    'assets/images/idl_adh.png',
  ];

  // fungsi text remaining waktu sholat
  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minute = d.inMinutes.remainder(60);
    return "$hours jam $minute menit lagi";
  }


  // state untuk dijalankan diawal
  @override
  void initState() {
    super.initState();
  }

  Future<String> _getBackgroundImage(DateTime now) async {
    if (now.hour < 12) {
      return 'assets/images/bg_morning.png';
    } else if (now.hour < 18) {
      return 'assets/images/bg_morning.png';
    }

    return 'assets/images/bg_night.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // ======================================
            // Menu Waktu Sholat By Lokasi
            // =====================================
            _buildHeroSection(),
            const SizedBox(height: 65),

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

  // ==========================
  // Menu Hero Section Widget
  // ==========================
  Widget _buildHeroSection() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 290,
          decoration: BoxDecoration(
            color: Color(0xFFB3E5FC),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
            image: DecorationImage(
              image: AssetImage('assets/images/bg_afternoon.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Assalamu\'alaikum',
                  style: TextStyle(
                    fontFamily: 'PoppinsRegular',
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  'Ngargoyoso',
                  style: TextStyle(
                    fontFamily: 'PoppinsSemiBold',
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                Text(
                  DateFormat('HH:mm').format(DateTime.now()),
                  style: TextStyle(
                    fontFamily: 'PoppinsBold',
                    fontSize: 50,
                    height: 1.2,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),

        Positioned(
          bottom: -55,
          left: 20,
          right: 20,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  blurRadius: 2,
                  offset: Offset(0, 4),
                  color: Colors.amber.withOpacity(0.4),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 14),
            child: Column(
              children: [
                Text(
                  'Waktu Sholat Berikutnya..',
                  style: TextStyle(
                    fontFamily: 'PoppinsRegular',
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'ASHAR',
                  style: TextStyle(
                    fontFamily: 'PoppinsBold',
                    fontSize: 20,
                    color: Colors.amber,
                  ),
                ),
                Text(
                  '14:22',
                  style: TextStyle(
                    fontFamily: 'PoppinsBold',
                    fontSize: 28,
                    color: Colors.black38,
                  ),
                ),
                Text(
                  '5 Jam 10 Menit',
                  style: TextStyle(
                    fontFamily: 'PoppinsRegular',
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ignore: slash_for_doc_comments
  /**
 * ============================
 * Menu Item Widget
 * ============================
 */

  Widget _buildMenuItem(String iconPath, String title, String routeName) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, routeName);
        },
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.amber.withOpacity(0.2),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(iconPath, width: 35),
              const SizedBox(height: 6),
              Text(title, style: TextStyle(fontFamily: 'PoppinsRegular')),
            ],
          ),
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
        crossAxisCount: 4, // max 4 baris
        shrinkWrap: true,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildMenuItem(
            'assets/images/ic_menu_doa.png', // IconPath
            'Doa', // Title
            '/doa', // RouteName
          ),

          _buildMenuItem(
            'assets/images/ic_menu_jadwal_sholat.png', // IconPath
            'Sholat', // Title
            '/sholat', // RouteName
          ),

          _buildMenuItem(
            'assets/images/ic_menu_video_kajian.png', // IconPath
            'Kajian', // Title
            '/kajian', // RouteName
          ),

          _buildMenuItem(
            'assets/images/ic_menu_zakat.png', // IconPath
            'Zakat', // Title
            '/zakat', // RouteName
          ),

          _buildMenuItem(
            'assets/images/ic_menu_doa.png', // IconPath
            'Khutbah', // Title
            '/khutbah', // RouteName
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
                  color: _currentIndex == entry.key
                      ? Colors.amber
                      : Colors.grey[400],
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
