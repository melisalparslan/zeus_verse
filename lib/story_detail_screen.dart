import 'package:flutter/material.dart';

class StoryDetailScreen extends StatelessWidget {
  final String title;

  const StoryDetailScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
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
                  image: const DecorationImage(
                    image: AssetImage(
                        'assets/images/81b382ad480749e69ffbb0e28ef47b051.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Playfair Display',
                  fontSize: 28,
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
                'Bu, $title hakkında detaylı bir yazıdır. Bu bölümde hikayenin içeriği yer alacak.',
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Daha fazla bilgi için diğer bölümleri okuyabilirsiniz.',
                style: TextStyle(
                  color: Color.fromRGBO(148, 148, 148, 1),
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
