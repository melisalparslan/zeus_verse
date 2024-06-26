import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'edit_profile_screen.dart';
import 'create_story_screen.dart';
import 'edit_story_screen.dart';
import 'story_detail_screen.dart';
import '../services/favorite_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user;
  String username = '';
  String bio = '';
  String photoUrl = '';

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _loadUserData();
    _checkFavorites();
  }

  Future<void> _loadUserData() async {
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user!.uid).get();
      setState(() {
        username = userDoc['username'] ?? 'User';
        bio = userDoc['bio'] ?? 'Bu bir biyografi.';
        photoUrl = userDoc['photoUrl'] ?? 'assets/images/41.png';
      });
    }
  }

  Stream<QuerySnapshot> _getUserStories() {
    return _firestore
        .collection('stories')
        .where('userId', isEqualTo: user!.uid)
        .snapshots();
  }

  Stream<QuerySnapshot> _getFavoriteStories() {
    return _firestore
        .collection('users')
        .doc(user!.uid)
        .collection('favorites')
        .snapshots();
  }

  Future<void> _checkFavorites() async {
    if (user != null) {
      QuerySnapshot favoriteStories = await _firestore
          .collection('users')
          .doc(user!.uid)
          .collection('favorites')
          .get();

      for (var doc in favoriteStories.docs) {
        String storyId = doc.id;
        DocumentSnapshot storySnapshot =
            await _firestore.collection('stories').doc(storyId).get();

        if (!storySnapshot.exists) {
          await FavoriteService.removeFavorite(storyId);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/auth');
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(
                    username: username,
                    bio: bio,
                    photoUrl: photoUrl,
                    onSave: _loadUserData,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: photoUrl.startsWith('assets/')
                          ? AssetImage(photoUrl)
                          : CachedNetworkImageProvider(photoUrl),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      username,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Sahitya',
                        fontSize: 36,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      bio,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color.fromRGBO(251, 251, 251, 1),
                        fontFamily: 'Sahitya',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildStatsRow(),
                    const SizedBox(height: 20),
                    _buildDivider('FAVORİ KONULARIM'),
                    const SizedBox(height: 20),
                    StreamBuilder<QuerySnapshot>(
                      stream: _getFavoriteStories(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Text(
                            'Henüz favori hikaye yok.',
                            style: TextStyle(color: Colors.white),
                          );
                        }
                        return Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: snapshot.data!.docs.map((doc) {
                            var data = doc.data() as Map<String, dynamic>;
                            return _buildFavoriteStoryTile(
                              context,
                              doc.id, // storyId
                              data['title'],
                              data['imagePath'],
                              data['author'],
                              data['content'],
                              data['subject'],
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildDivider('HİKAYELERİM'),
                    const SizedBox(height: 20),
                    StreamBuilder<QuerySnapshot>(
                      stream: _getUserStories(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Text(
                            'Henüz hikaye oluşturulmamış.',
                            style: TextStyle(color: Colors.white),
                          );
                        }
                        return Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: snapshot.data!.docs.map((doc) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditStoryScreen(
                                      storyId: doc.id,
                                      initialTitle: doc['title'],
                                      initialContent: doc['content'],
                                      initialImagePath: doc['image'],
                                      initialSubject: doc['subject'],
                                    ),
                                  ),
                                );
                              },
                              child: _buildImageContainer(
                                  doc['title'], doc['image']),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateStoryScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(41, 182, 246, 1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Hikaye Oluştur'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteStoryTile(
    BuildContext context,
    String storyId,
    String title,
    String imagePath,
    String author,
    String content,
    String subject,
  ) {
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
      child: _buildImageContainer(title, imagePath),
    );
  }

  Widget _buildImageContainer(String title, String imagePath) {
    return SizedBox(
      width: 93,
      height: 94,
      child: Stack(
        children: [
          Container(
            width: 93,
            height: 94,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 6,
                ),
              ],
              image: DecorationImage(
                image: imagePath.startsWith('assets/')
                    ? AssetImage(imagePath)
                    : CachedNetworkImageProvider(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            left: 5,
            right: 5,
            child: Container(
              color: Colors.black54,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatsColumn('465', 'Okunan Hikaye'),
        _buildStatsColumn('8.7/10', 'Yazar Puanı'),
        _buildStatsColumn('1.2k', 'Beğeniler'),
      ],
    );
  }

  Widget _buildStatsColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Sahitya',
            fontSize: 36,
            fontWeight: FontWeight.normal,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color.fromRGBO(148, 148, 148, 1),
            fontFamily: 'Sahitya',
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(String text) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: Colors.white,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Righteous',
              fontSize: 16,
              fontWeight: FontWeight.normal,
              height: 1.5,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: Colors.white,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
