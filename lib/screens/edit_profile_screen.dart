import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  final String username;
  final String bio;
  final String photoUrl;
  final VoidCallback onSave;

  const EditProfileScreen({
    super.key,
    required this.username,
    required this.bio,
    required this.photoUrl,
    required this.onSave,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _bioController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  File? _imageFile;
  String? _selectedImagePath;

  final List<String> _assetsImages = [
    'assets/images/41.png',
    'assets/images/Up1.png',
    'assets/images/images.jpeg',
    // Daha fazla resim ekleyebilirsiniz.
  ];

  @override
  void initState() {
    super.initState();
    _bioController.text = widget.bio;
    _selectedImagePath = widget.photoUrl;
  }

  Future<void> _pickImageFromAssets() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bir Resim Seçin',
              style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromRGBO(13, 64, 93, 1),
          content: SingleChildScrollView(
            child: Column(
              children: _assetsImages.map((imagePath) {
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

  Future<String> _uploadImage(File imageFile) async {
    String fileName = 'profile_images/${_auth.currentUser!.uid}.png';
    Reference storageRef = _storage.ref().child(fileName);
    UploadTask uploadTask = storageRef.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> _saveProfile() async {
    User? user = _auth.currentUser;
    String? photoUrl = _selectedImagePath;

    if (_imageFile != null && user != null) {
      photoUrl = await _uploadImage(_imageFile!);
    }

    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'bio': _bioController.text,
        'photoUrl': photoUrl,
      });

      widget.onSave();
      Navigator.pop(context);
    }
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: _pickImageFromAssets,
      child: CircleAvatar(
        radius: 50,
        backgroundImage: _imageFile != null
            ? FileImage(_imageFile!)
            : (_selectedImagePath != null
                ? (_selectedImagePath!.startsWith('assets/')
                    ? AssetImage(_selectedImagePath!)
                    : NetworkImage(_selectedImagePath!)) as ImageProvider
                : const AssetImage('assets/images/default.png')),
      ),
    );
  }

  Widget _buildBioTextField() {
    return TextField(
      controller: _bioController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        hintStyle: const TextStyle(color: Colors.white70),
        labelStyle: const TextStyle(color: Colors.white),
      ),
      maxLines: 3,
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveProfile,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(41, 182, 246, 1),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      child: const Text('Kaydet'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Düzenle'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
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
            children: <Widget>[
              const SizedBox(height: 20),
              _buildProfileImage(),
              const SizedBox(height: 20),
              Text(
                widget.username,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Biyografi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildBioTextField(),
              const SizedBox(height: 20),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }
}
