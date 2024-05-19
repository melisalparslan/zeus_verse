import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_profile_screen.dart';
import 'create_story_screen.dart';
import 'edit_story_screen.dart';

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
                          onSave:
                              _loadUserData, // Save işleminden sonra verileri yenile
                        )),
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
                          : NetworkImage(photoUrl) as ImageProvider,
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
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        _buildImageContainer('Flutter',
                            'assets/images/What_is_flutter_f648a606af1.png'),
                        _buildImageContainer('Dart',
                            'assets/images/Comoinstalarodarteexecutarseuprimeiroexemplo1.png'),
                        _buildImageContainer(
                            'Golang', 'assets/images/Images1.png'),
                      ],
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
                                doc['title'],
                                doc['image'],
                              ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
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
                    : NetworkImage(imagePath) as ImageProvider,
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
