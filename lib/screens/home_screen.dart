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
            _buildAppBar(context, user),
            _buildFeaturedStories(context, screenSize),
            _buildStoriesTitle(context),
            _buildStoryGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, User? user) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 21,
      left: 21,
      right: 21,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'ZeusVerse',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Playfair Display',
              fontSize: 30,
              fontWeight: FontWeight.normal,
            ),
          ),
          FutureBuilder<DocumentSnapshot>(
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
        ],
      ),
    );
  }

  Widget _buildFeaturedStories(BuildContext context, Size screenSize) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 100,
      left: 0,
      right: 0,
      child: Column(
        children: [
          _buildSectionTitle('Öne Çıkan Hikayeler'),
          const SizedBox(height: 10),
          CarouselSlider(
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
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 5),
            child: const Divider(
              color: Colors.white,
              thickness: 1.5,
              endIndent: 5,
              indent: 5,
            ),
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 5, right: 10),
            child: const Divider(
              color: Colors.white,
              thickness: 1.5,
              endIndent: 5,
              indent: 5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStoriesTitle(BuildContext context) {
    return Positioned(
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
    );
  }

  Widget _buildStoryGrid(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 360,
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: stories.length,
            itemBuilder: (context, index) {
              var storyDoc = stories[index];
              var story = storyDoc.data() as Map<String, dynamic>;

              var userId = story['userId'];
              if (userId == null || userId == 'Admin') {
                // Admin'e ait hikaye
                return _buildStoryTile(
                  context,
                  storyDoc.id,
                  story['title'],
                  story['image'],
                  'Admin',
                  story['content'],
                  story['subject'],
                );
              } else {
                // Kullanıcıya ait hikaye
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
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
                    var userData =
                        userSnapshot.data!.data() as Map<String, dynamic>;
                    var username = userData['username'];
                    return _buildStoryTile(
                      context,
                      storyDoc.id,
                      story['title'],
                      story['image'],
                      username,
                      story['content'],
                      story['subject'],
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildStoryTile(BuildContext context, String storyId, String title,
      String imagePath, String author, String content, String subject) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryDetailScreen(
              storyId: storyId,
              title: title,
              subject: subject,
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
