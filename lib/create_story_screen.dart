import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateStoryScreen extends StatefulWidget {
  const CreateStoryScreen({super.key});

  @override
  _CreateStoryScreenState createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _selectedImagePath;

  final List<String> _images = [
    'assets/images/21e5d95d540947a69e18bbc20ab0bedf1.png',
    'assets/images/0d533685c3b64bdf94dd74b5c8fe4d051.png',
    'assets/images/6b30182b20f144399d46ca377ff609411.png',
    // Daha fazla resim ekleyebilirsiniz.
  ];

  Future<void> _saveStory() async {
    if (_titleController.text.isEmpty ||
        _contentController.text.isEmpty ||
        _selectedImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Lütfen tüm alanları doldurun ve bir resim seçin.')),
      );
      return;
    }

    try {
      User? user = _auth.currentUser;

      await _firestore.collection('stories').add({
        'title': _titleController.text,
        'content': _contentController.text,
        'image': _selectedImagePath,
        'userId': user!.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hikaye başarıyla oluşturuldu.')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hikaye oluşturulurken bir hata oluştu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hikaye Oluştur'),
        titleTextStyle: const TextStyle(color: Colors.white),
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              const Text(
                'Bir Resim Seçin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _images.map((imagePath) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImagePath = imagePath;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedImagePath == imagePath
                                ? Colors.blue
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: Image.asset(imagePath, height: 100),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Başlık (En fazla 2 kelime)',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Hikaye',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                maxLines: 5,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveStory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(41, 182, 246, 1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Kaydet'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
