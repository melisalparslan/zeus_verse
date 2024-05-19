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

    final List<String> adminContents = [
      '''Biyoinformatik, biyolojik verilerin toplanması, analizi ve yorumlanması için bilgi teknolojilerini kullanan bir bilim dalıdır. Bu alanda çalışan bilim insanları, genetik dizilimlerin analizinden protein yapılarının tahminine kadar çeşitli konularda çalışmalar yaparlar. Biyoinformatik, modern biyoloji ve tıp alanında büyük öneme sahiptir.''',
      '''Flutter, Google tarafından geliştirilen açık kaynaklı bir mobil uygulama geliştirme framework'üdür. Flutter, tek bir kod tabanı ile hem iOS hem de Android uygulamaları oluşturmanıza olanak tanır. Hızlı geliştirme, zengin widget seti ve yüksek performans sunar.''',
      '''Nanoteknoloji, atom ve molekül ölçeğinde maddelerin kontrol edilmesi ve manipüle edilmesiyle ilgilenen bir bilim dalıdır. Bu teknoloji, sağlık, elektronik, çevre ve enerji gibi birçok alanda devrim niteliğinde yenilikler sunmaktadır. Nanoteknoloji sayesinde daha güçlü malzemeler, daha küçük elektronik cihazlar ve daha etkili tıbbi tedaviler geliştirilmektedir.''',
      '''Unity, video oyunları, simülasyonlar ve diğer interaktif deneyimler oluşturmak için kullanılan bir oyun motorudur. C# programlama dili ile kullanılır ve geniş bir platform desteği sunar.''',
      '''C#, Microsoft tarafından geliştirilen modern, nesne yönelimli bir programlama dilidir. .NET Framework ile birlikte kullanılır ve geniş bir uygulama yelpazesi için uygundur, özellikle web, masaüstü ve mobil uygulamalar geliştirmek için tercih edilir.''',
      '''Uzay kolonizasyonu, insanlığın dünya dışındaki gezegenlerde veya uydularda kalıcı olarak yaşama ve çalışma yeteneği kazanması sürecidir. Bu süreç, teknolojik, biyolojik ve sosyal birçok zorluğun üstesinden gelmeyi gerektirir.''',
      '''Genetik, kalıtım ve varyasyonun biyolojik temellerini inceleyen bir bilim dalıdır. Genetik mühendisliği, DNA'nın değiştirilmesi ve yeni organizmaların yaratılması için genetik bilgiyi kullanır.''',
      '''Kuantum fiziği, atom ve atom altı parçacıkların davranışlarını inceleyen bir fizik dalıdır. Kuantum bilgisayarları, geleneksel bilgisayarlardan çok daha hızlı işlem yapabilen cihazlardır.''',
      '''Javascript, web geliştirme için kullanılan yaygın bir programlama dilidir. Hem istemci tarafında hem de sunucu tarafında kullanılabilir. HTML ve CSS ile birlikte çalışarak dinamik ve etkileşimli web sayfaları oluşturulmasına olanak tanır.''',
    ];

    final List<String> adminSubjects = [
      'Biyoinformatik Öğreniyorum',
      'Flutter',
      'Nanoteknoloji',
      'Unity',
      'C#',
      'Uzay Kolonizasyonu',
      'Genetik',
      'Kuantum Fiziği',
      'Javascript',
    ];

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
                    itemCount: stories.length + adminContents.length,
                    itemBuilder: (context, index) {
                      if (index < adminContents.length) {
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
                          adminContents[index],
                          adminSubjects[index],
                        );
                      } else {
                        // Dinamik hikayeler
                        var story = stories[index - adminContents.length];
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
                              story['subject'], // title as subject
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
      String author, String content, String subject) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryDetailScreen(
              title: title,
              subject: subject, // Konu başlığı
              imagePath: imagePath,
              author: author,
              content: content,
              isAdmin: author == 'Admin',
            ),
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
