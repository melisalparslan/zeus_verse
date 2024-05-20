import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteService {
  static Future<bool> isFavorite(String storyId) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(storyId)
          .get();
      return snapshot.exists;
    }
    return false;
  }

  static Future<void> toggleFavorite({
    required String storyId,
    required String title,
    required String subject,
    required String imagePath,
    required String author,
    required String content,
    required bool isAdmin,
    required bool isFavorite,
  }) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final favoritesCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites');

      if (isFavorite) {
        await favoritesCollection.doc(storyId).delete();
      } else {
        await favoritesCollection.doc(storyId).set({
          'storyId': storyId,
          'title': title,
          'subject': subject,
          'imagePath': imagePath,
          'author': author,
          'content': content,
          'isAdmin': isAdmin,
        });
      }
    }
  }

  static Future<void> removeFavorite(String storyId) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final favoritesCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites');
      await favoritesCollection.doc(storyId).delete();
    }
  }
}
