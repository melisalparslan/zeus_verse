// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditStoryScreen extends StatefulWidget {
  final String storyId;
  final String initialTitle;
  final String initialContent;
  final String initialImagePath;

  const EditStoryScreen({
    super.key,
    required this.storyId,
    required this.initialTitle,
    required this.initialContent,
    required this.initialImagePath,
  });

  @override
  _EditStoryScreenState createState() => _EditStoryScreenState();
}

class _EditStoryScreenState extends State<EditStoryScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late String _selectedImagePath;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _contentController = TextEditingController(text: widget.initialContent);
    _selectedImagePath = widget.initialImagePath;
  }

  Future<void> _selectImage() async {
    final images = [
      'assets/images/21e5d95d540947a69e18bbc20ab0bedf1.png',
      'assets/images/0d533685c3b64bdf94dd74b5c8fe4d051.png',
      'assets/images/6b30182b20f144399d46ca377ff609411.png',
      // Daha fazla resim ekleyebilirsiniz.
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bir Resim Seçin'),
          backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
          titleTextStyle: const TextStyle(color: Colors.white),
          content: SingleChildScrollView(
            child: Column(
              children: images.map((imagePath) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedImagePath = imagePath;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Image.asset(imagePath, height: 100),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveStory() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun.')),
      );
      return;
    }

    try {
      await _firestore.collection('stories').doc(widget.storyId).update({
        'title': _titleController.text,
        'content': _contentController.text,
        'image': _selectedImagePath,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hikaye başarıyla güncellendi.')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hikaye güncellenirken bir hata oluştu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hikaye Düzenle'),
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
              GestureDetector(
                onTap: _selectImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _selectedImagePath != null
                      ? AssetImage(_selectedImagePath)
                      : const AssetImage('assets/images/placeholder.png'),
                  child: _selectedImagePath == null
                      ? const Icon(
                          Icons.add_a_photo,
                          color: Colors.black,
                          size: 30,
                        )
                      : null,
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
