import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'profile_screen.dart';
import 'story_detail_screen.dart';
// Yeni eklenen dosya

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color.fromRGBO(13, 64, 93, 1),
              Color.fromRGBO(0, 0, 0, 1),
            ],
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: MediaQuery.of(context).padding.top + 21,
              left: 21,
              child: const Text(
                'ZeusVerse',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Playfair Display',
                  fontSize: 30,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 21,
              right: 21,
              child: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user?.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData ||
                      snapshot.data == null ||
                      !snapshot.data!.exists) {
                    return const Icon(Icons.error);
                  }
                  var userData = snapshot.data!;
                  var photoUrl = userData['photoUrl'] ?? 'assets/images/41.png';
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileScreen()),
                      );
                    },
                    child: CircleAvatar(
                      radius: 21,
                      backgroundImage: photoUrl.startsWith('assets/')
                          ? AssetImage(photoUrl)
                          : NetworkImage(photoUrl) as ImageProvider,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 124,
              left: 0,
              right: 0,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 180,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
                items: [
                  'assets/images/81b382ad480749e69ffbb0e28ef47b051.png',
                  'assets/images/21e5d95d540947a69e18bbc20ab0bedf1.png',
                  'assets/images/0d533685c3b64bdf94dd74b5c8fe4d051.png',
                ].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: screenSize.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(i),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 329,
              left: 18,
              right: 18,
              child: const Row(
                children: [
                  Text(
                    'HİKAYELER',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Roboto',
                      fontSize: 22,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 325,
              left: 18,
              right: 18,
              bottom: 18,
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: <Widget>[
                  _buildStoryTile(context, 'Biyoinformatik',
                      'assets/images/21e5d95d540947a69e18bbc20ab0bedf1.png'),
                  _buildStoryTile(context, 'Flutter',
                      'assets/images/0d533685c3b64bdf94dd74b5c8fe4d051.png'),
                  _buildStoryTile(context, 'Nanoteknoloji',
                      'assets/images/6b30182b20f144399d46ca377ff609411.png'),
                  _buildStoryTile(context, 'Unity',
                      'assets/images/A3dae15046ed450d9ddaaaaf46eb5faf1.png'),
                  _buildStoryTile(context, 'C#',
                      'assets/images/9a47f3b6473b45fca35a13fa376e47871.png'),
                  _buildStoryTile(context, 'Uzay Kolonizasyonu',
                      'assets/images/Fa969a35a75545618150d3c84cadc2e31.png'),
                  _buildStoryTile(context, 'Genetik',
                      'assets/images/Fa2b95f37f0a4509bbbd87addd5d08cc1.png'),
                  _buildStoryTile(context, 'Kuantum Fiziği',
                      'assets/images/61371cb1497a45b0b17b4a5d93af59e41.png'),
                  _buildStoryTile(context, 'Javascript',
                      'assets/images/410b2c9d7fe04cda9534eec2c0650dc81.png'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryTile(BuildContext context, String title, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryDetailScreen(title: title),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  offset: Offset(0, 4),
                  blurRadius: 4,
                ),
              ],
              border: Border.all(
                color: const Color.fromRGBO(0, 0, 0, 1),
                width: 1,
              ),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 5,
            left: 8,
            right: 8,
            child: Container(
              color: Colors.black54,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
