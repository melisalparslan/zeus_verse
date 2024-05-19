import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'profile_screen.dart';
import 'story_detail_screen.dart';

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
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('stories')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  var stories = snapshot.data!.docs;

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: stories.length +
                        9, // 9 sabit hikaye + dinamik hikayeler
                    itemBuilder: (context, index) {
                      if (index < 9) {
                        // Sabit hikayeler
                        var titles = [
                          'Biyoinformatik',
                          'Flutter',
                          'Nanoteknoloji',
                          'Unity',
                          'C#',
                          'Uzay Kolonizasyonu',
                          'Genetik',
                          'Kuantum Fiziği',
                          'Javascript',
                        ];
                        var images = [
                          'assets/images/21e5d95d540947a69e18bbc20ab0bedf1.png',
                          'assets/images/0d533685c3b64bdf94dd74b5c8fe4d051.png',
                          'assets/images/6b30182b20f144399d46ca377ff609411.png',
                          'assets/images/A3dae15046ed450d9ddaaaaf46eb5faf1.png',
                          'assets/images/9a47f3b6473b45fca35a13fa376e47871.png',
                          'assets/images/Fa969a35a75545618150d3c84cadc2e31.png',
                          'assets/images/Fa2b95f37f0a4509bbbd87addd5d08cc1.png',
                          'assets/images/61371cb1497a45b0b17b4a5d93af59e41.png',
                          'assets/images/410b2c9d7fe04cda9534eec2c0650dc81.png',
                        ];
                        return _buildStoryTile(
                            context,
                            titles[index],
                            images[index],
                            'Admin',
                            'Zeus, antik Yunan\'daki tanrıların tanrısı, dünyada teknolojinin yükselişini fark ederek insanlarla yeni bir iletişim yolu bulmak istedi. Zeus, oğluna dönerek, "Apollo, dünyada neler olup bittiğini görüyorum. İnsanlar artık tanrılarla eskisi gibi konuşmuyor. Onlarla iletişim kurmanın yeni yollarını bulmalıyız. Bana bu yeni dünyayı öğret," dedi. Zeus oğlu Apollo\'nun yardımıyla Flutter\'ı öğretmeye başladı. İlk adım olarak, Zeus\'a Dart dilini gösterdi. Zeus, kod yazmayı, ikinci adım olarak, Flutter Flow\'u kullanmayı öğrendi. Flutter Flow, kodsuz veya az kodlu bir platform olarak Zeus\'un hızlıca uygulama geliştirmesine yardımcı oldu. Zeus, tanrılarla insanların bağlantısını yeniden kurmak için "Olympus Connect" adlı bir mobil uygulama geliştirdi. Zeus, uygulamayı geliştirirken, Flutter Flow\'un sürükle-bırak arayüzünü kullanarak tasarım ve işlevselliği bir araya getirdi. Apollo, müzik ve görsellerle uygulamayı zenginleştirdi. Athena, bilgeliğiyle uygulamanın içeriklerini düzenledi. Hermes, mesajlaşma ve iletişim özelliklerini ekledi. Hera, kullanıcılara ailevi bağları ve sevgiyi hatırlatan özellikler sundu. Olympus Connect hızla popüler oldu ve tanrılar, dijital dünyada da insanlarla bağlarını güçlendirdi. Böylece, Zeus ve tanrıları teknolojinin gücüyle yeni bir çağ açtılar.');
                      } else {
                        // Dinamik hikayeler
                        var story = stories[index - 9];
                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(story['userId'])
                              .get(),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (!userSnapshot.hasData ||
                                userSnapshot.data == null ||
                                !userSnapshot.data!.exists) {
                              return const Icon(Icons.error);
                            }
                            var userData = userSnapshot.data!;
                            var username = userData['username'];
                            return _buildStoryTile(
                              context,
                              story['title'],
                              story['image'],
                              username, // userId yerine username'i kullan
                              story['content'],
                            );
                          },
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryTile(BuildContext context, String title, String imagePath,
      String author, String content) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryDetailScreen(
                title: title,
                imagePath: imagePath,
                author: author,
                content: content,
                isAdmin: author == 'Admin'),
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
                image: imagePath.startsWith('assets/')
                    ? AssetImage(imagePath)
                    : NetworkImage(imagePath) as ImageProvider,
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
