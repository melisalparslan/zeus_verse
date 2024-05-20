import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/api_service.dart';
import '../services/favorite_service.dart';

class StoryDetailScreen extends StatefulWidget {
  final String storyId;
  final String title;
  final String subject;
  final String imagePath;
  final String author;
  final String content;
  final bool isAdmin;

  const StoryDetailScreen({
    super.key,
    required this.storyId,
    required this.title,
    required this.subject,
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
  Future<String>? _testQuestionFuture;
  final TextEditingController _testAnswerController = TextEditingController();
  String _testAnswerResult = '';
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  void _checkIfFavorite() async {
    final isFavorite = await FavoriteService.isFavorite(widget.storyId);
    setState(() {
      _isFavorite = isFavorite;
    });
  }

  void _toggleFavorite() async {
    await FavoriteService.toggleFavorite(
      storyId: widget.storyId,
      title: widget.title,
      subject: widget.subject,
      imagePath: widget.imagePath,
      author: widget.author,
      content: widget.content,
      isAdmin: widget.isAdmin,
      isFavorite: _isFavorite,
    );

    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void _askQuestion() {
    final questionController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color.fromRGBO(13, 64, 93, 1),
              title: const Text('Bir Soru Sor',
                  style: TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: questionController,
                    decoration: const InputDecoration(
                      hintText: 'Sorunuzu buraya yazın',
                      hintStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white24,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
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
                            style: const TextStyle(color: Colors.white),
                          );
                        }
                      },
                    ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Vazgeç',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      questionController.clear();
                      _answerFuture = null;
                    });
                  },
                ),
                TextButton(
                  child:
                      const Text('Sor', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    final question = questionController.text;
                    setState(() {
                      _answerFuture =
                          ApiService.getAnswer(question, widget.content);
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

  void _startMiniTest() {
    setState(() {
      _testQuestionFuture = ApiService.getTestQuestion(widget.content);
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color.fromRGBO(13, 64, 93, 1),
              title: const Text('Ai Mini Test',
                  style: TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_testQuestionFuture != null)
                    FutureBuilder<String>(
                      future: _testQuestionFuture,
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
                          return Column(
                            children: [
                              Text(
                                'Soru: ${snapshot.data}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: _testAnswerController,
                                decoration: const InputDecoration(
                                  hintText: 'Cevabınızı buraya yazın',
                                  hintStyle: TextStyle(color: Colors.white70),
                                  filled: true,
                                  fillColor: Colors.white24,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 20),
                              if (_testAnswerResult.isNotEmpty)
                                Text(
                                  _testAnswerResult,
                                  style: const TextStyle(color: Colors.white),
                                ),
                            ],
                          );
                        }
                      },
                    ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Vazgeç',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _testQuestionFuture = null;
                      _testAnswerController.clear();
                      _testAnswerResult = '';
                    });
                  },
                ),
                TextButton(
                  child: const Text('Gönder',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    // Bekleme animasyonu göster
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );

                    final question = await _testQuestionFuture!;
                    final answer = _testAnswerController.text;
                    final result = await ApiService.checkAnswer(
                        question, answer, widget.content);

                    // Bekleme animasyonunu kapat
                    Navigator.of(context).pop();

                    setState(() {
                      _testAnswerResult = 'Sonuç: $result';
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
        actions: <Widget>[
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
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
                        : CachedNetworkImageProvider(widget.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.subject,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Playfair Display',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 10),
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
                widget.content,
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
                      'Ai Sor',
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
                    onPressed: _startMiniTest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(41, 182, 246, 1),
                    ),
                    child: const Text(
                      'Ai Mini Test',
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
