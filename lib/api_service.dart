import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const apiKey = 'AIzaSyAQBSeCPXoPaqReosNa69t6M3cRGtTU-gU';

  static Future<String> getAnswer(String question, String storyContent) async {
    if (apiKey.isEmpty) {
      return 'API_KEY not found';
    }

    const url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey';
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'contents': [
        {
          'parts': [
            {'text': 'Soru: $question \nHikaye: $storyContent'}
          ]
        }
      ]
    });

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final answer =
            responseData['candidates'][0]['content']['parts'][0]['text'];
        return answer;
      } else {
        return 'Bir hata oluştu.';
      }
    } catch (e) {
      return 'Bir hata oluştu: $e';
    }
  }

  static Future<String> getTestQuestion(String storyContent) async {
    if (apiKey.isEmpty) {
      return 'API_KEY not found';
    }

    const url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey';
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'contents': [
        {
          'parts': [
            {
              'text':
                  'Konu: $storyContent hakkında 4 şıklı bir mini test sorusu oluştur..'
            }
          ]
        }
      ]
    });

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final question =
            responseData['candidates'][0]['content']['parts'][0]['text'];
        return question;
      } else {
        return 'Bir hata oluştu.';
      }
    } catch (e) {
      return 'Bir hata oluştu: $e';
    }
  }

  static Future<String> checkAnswer(String question, String userAnswer) async {
    if (apiKey.isEmpty) {
      return 'API_KEY not found';
    }

    const url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey';
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'contents': [
        {
          'parts': [
            {
              'text':
                  'Soru: $question \nKullanıcı Cevabı: $userAnswer. Bu cevap doğru mu?'
            }
          ]
        }
      ]
    });

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final result =
            responseData['candidates'][0]['content']['parts'][0]['text'];
        return result;
      } else {
        return 'Bir hata oluştu.';
      }
    } catch (e) {
      return 'Bir hata oluştu: $e';
    }
  }
}
