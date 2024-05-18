import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_profile_screen.dart';

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
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
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
                        backgroundImage: AssetImage(photoUrl),
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
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                '465',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Sahitya',
                                  fontSize: 36,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                'Okunan Hikaye',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color.fromRGBO(148, 148, 148, 1),
                                  fontFamily: 'Sahitya',
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '8.7/10',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Sahitya',
                                  fontSize: 36,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                'Yazar Puanı',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color.fromRGBO(148, 148, 148, 1),
                                  fontFamily: 'Sahitya',
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '1.2k',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Sahitya',
                                  fontSize: 36,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                'Beğeniler',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color.fromRGBO(148, 148, 148, 1),
                                  fontFamily: 'Sahitya',
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.white,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'FAVORİ KONULARIM',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Righteous',
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                height: 1.5,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.white,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
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
                      const Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.white,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'HİKAYELERİM',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Righteous',
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                height: 1.5,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.white,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: [
                          _buildImageContainer('OpenAI 101',
                              'assets/images/_8e73d004f4d44282971ce786216853f31.png'),
                          _buildImageContainer(
                              'Bard 101', 'assets/images/Googlebard1.png'),
                          _buildImageContainer('Yapay Zeka 101',
                              'assets/images/Yapayzekanedir1.png'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
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
              image: DecorationImage(
                image: AssetImage(imagePath),
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

  Widget _buildTextContainer(String text) {
    return Text(
      text,
      textAlign: TextAlign.left,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'Sahitya',
        fontSize: 20,
        fontWeight: FontWeight.normal,
        height: 1.2,
      ),
    );
  }
}
