import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StoryDetailScreen extends StatefulWidget {
  final String title;
  final String imagePath;
  final String author;
  final String content;
  final bool isAdmin;

  const StoryDetailScreen({
    super.key,
    required this.title,
    required this.imagePath,
    required this.author,
    required this.content,
    this.isAdmin = false,
  });

  @override
  _StoryDetailScreenState createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  Future<String>? _answerFuture;

  Future<String> _getAnswer(String question, String storyContent) async {
    const apiKey = 'AIzaSyAQBSeCPXoPaqReosNa69t6M3cRGtTU-gU';
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

  void _askQuestion() {
    final questionController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Bir Soru Sor'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: questionController,
                    decoration: const InputDecoration(
                      hintText: 'Sorunuzu buraya yazın',
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_answerFuture != null)
                    FutureBuilder<String>(
                      future: _answerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text(
                            'Hata: ${snapshot.error}',
                            style: const TextStyle(color: Colors.red),
                          );
                        } else {
                          return Text(
                            'Cevap: ${snapshot.data}',
                            style: const TextStyle(color: Colors.black),
                          );
                        }
                      },
                    ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Vazgeç'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Sor'),
                  onPressed: () {
                    final question = questionController.text;
                    setState(() {
                      _answerFuture = _getAnswer(question, widget.content);
                    });
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Playfair Display',
            fontSize: 24,
            fontWeight: FontWeight.normal,
          ),
        ),
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
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: widget.imagePath.startsWith('assets/')
                        ? AssetImage(widget.imagePath)
                        : NetworkImage(widget.imagePath) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Playfair Display',
                  fontSize: 28,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                'Yazar: ${widget.author}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontFamily: 'Playfair Display',
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 10),
              const Divider(
                color: Colors.white,
                thickness: 2,
              ),
              const SizedBox(height: 10),
              Text(
                widget.isAdmin
                    ? '''Zeus, antik Yunan'daki tanrıların tanrısı, dünyada teknolojinin yükselişini fark ederek insanlarla yeni bir iletişim yolu bulmak istedi. Zeus, oğluna dönerek, "Apollo, dünyada neler olup bittiğini görüyorum. İnsanlar artık tanrılarla eskisi gibi konuşmuyor. Onlarla iletişim kurmanın yeni yollarını bulmalıyız. Bana bu yeni dünyayı öğret," dedi. Zeus oğlu Apollo'nun yardımıyla Flutter'ı öğretmeye başladı. İlk adım olarak, Zeus'a Dart dilini gösterdi. Zeus, kod yazmayı, ikinci adım olarak, Flutter Flow'u kullanmayı öğrendi. Flutter Flow, kodsuz veya az kodlu bir platform olarak Zeus'un hızlıca uygulama geliştirmesine yardımcı oldu. Zeus, tanrılarla insanların bağlantısını yeniden kurmak için "Olympus Connect" adlı bir mobil uygulama geliştirdi. Zeus, uygulamayı geliştirirken, Flutter Flow'un sürükle-bırak arayüzünü kullanarak tasarım ve işlevselliği bir araya getirdi. Apollo, müzik ve görsellerle uygulamayı zenginleştirdi. Athena, bilgeliğiyle uygulamanın içeriklerini düzenledi. Hermes, mesajlaşma ve iletişim özelliklerini ekledi. Hera, kullanıcılara ailevi bağları ve sevgiyi hatırlatan özellikler sundu. Olympus Connect hızla popüler oldu ve tanrılar, dijital dünyada da insanlarla bağlarını güçlendirdi. Böylece, Zeus ve tanrıları teknolojinin gücüyle yeni bir çağ açtılar.'''
                    : widget.content,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _askQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(41, 182, 246, 1),
                    ),
                    child: const Text(
                      'Soru Sor',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(41, 182, 246, 1),
                    ),
                    child: const Text(
                      'Tartışma',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(41, 182, 246, 1),
                    ),
                    child: const Text(
                      'Mini Test',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
