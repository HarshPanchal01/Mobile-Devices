import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twitter UI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Twitter UI'),
      ),
      body: ListView(
        children: const [
          TweetWidget(
            userShortName: 'JohnDoe',
            userLongName: 'John Doe',
            timeString: '2h',
            description: 'This is a sample tweet description.',
            imagePath: 'assets/image1.png',
            numComments: 10,
            numRetweets: 5,
            numLikes: 20,
          ),
          TweetWidget(
            userShortName: 'JaneSmith',
            userLongName: 'Jane Smith',
            timeString: '3h',
            description: 'Another sample tweet description.',
            imagePath: 'assets/image2.png',
            numComments: 15,
            numRetweets: 7,
            numLikes: 25,
          ),
          TweetWidget(
            userShortName: 'AliceJohnson',
            userLongName: 'Alice Johnson',
            timeString: '1h',
            description: 'Yet another sample tweet description.',
            imagePath: 'assets/image3.png',
            numComments: 20,
            numRetweets: 10,
            numLikes: 30,
          ),
        ],
      ),
    );
  }
}

class TweetWidget extends StatelessWidget {
  final String userShortName;
  final String userLongName;
  final String timeString;
  final String description;
  final String imagePath;
  final int numComments;
  final int numRetweets;
  final int numLikes;

  const TweetWidget({
    required this.userShortName,
    required this.userLongName,
    required this.timeString,
    required this.description,
    required this.imagePath,
    required this.numComments,
    required this.numRetweets,
    required this.numLikes,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/image4.png'),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(userLongName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    Text('@$userShortName'),
                    const SizedBox(width: 5),
                    Text('· $timeString'),
                    const Spacer(),
                    const Icon(Icons.expand_more),
                  ],
                ),
                const SizedBox(height: 5),
                Text(description),
                const SizedBox(height: 5),
                Image.asset(imagePath),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.chat_bubble_outline),
                        const SizedBox(width: 5),
                        Text('$numComments'),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.repeat),
                        const SizedBox(width: 5),
                        Text('$numRetweets'),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.favorite_border),
                        const SizedBox(width: 5),
                        Text('$numLikes'),
                      ],
                    ),
                    const Icon(Icons.bookmark_border),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
