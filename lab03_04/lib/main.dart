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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Tweet> tweets = [
    Tweet(
      userShortName: 'JohnDoe',
      userLongName: 'John Doe',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      description: 'This is a sample tweet description.',
      imagePath: 'assets/image1.png',
      numComments: 10,
      numRetweets: 5,
      numLikes: 20,
    ),
    Tweet(
      userShortName: 'JaneSmith',
      userLongName: 'Jane Smith',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      description: 'Another sample tweet description.',
      imagePath: 'assets/image2.png',
      numComments: 15,
      numRetweets: 7,
      numLikes: 25,
    ),
    Tweet(
      userShortName: 'AliceJohnson',
      userLongName: 'Alice Johnson',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      description: 'Yet another sample tweet description.',
      imagePath: 'assets/image3.png',
      numComments: 20,
      numRetweets: 10,
      numLikes: 30,
    ),
  ];

  void _addTweet(Tweet tweet) {
    setState(() {
      tweets.insert(0, tweet);
    });
  }

  void _toggleLike(Tweet tweet) {
    setState(() {
      tweet.isLiked = !tweet.isLiked;
      tweet.numLikes += tweet.isLiked ? 1 : -1;
    });
  }

  void _toggleRetweet(Tweet tweet) {
    setState(() {
      tweet.isRetweeted = !tweet.isRetweeted;
      tweet.numRetweets += tweet.isRetweeted ? 1 : -1;
    });
  }

  void _hideTweet(Tweet tweet) {
    setState(() {
      tweets.remove(tweet);
    });
  }

  void _replyToTweet(Tweet tweet, String reply) {
    setState(() {
      tweet.numComments += 1;
      tweets.insert(tweets.indexOf(tweet) + 1, Tweet(
        userShortName: 'CurrentUser',
        userLongName: 'Current User',
        timestamp: DateTime.now(),
        description: reply,
        imagePath: '',
        numComments: 0,
        numRetweets: 0,
        numLikes: 0,
      ));
    });
  }

  void _toggleBookmark(Tweet tweet) {
    setState(() {
      tweet.isBookmarked = !tweet.isBookmarked;
      tweets.remove(tweet);
      if (tweet.isBookmarked) {
        tweets.insert(0, tweet);
      } else {
        tweets.add(tweet);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('lab 03 04'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewTweetPage(onSubmit: _addTweet)),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: tweets.map((tweet) => TweetWidget(
          tweet: tweet,
          onLike: () => _toggleLike(tweet),
          onRetweet: () => _toggleRetweet(tweet),
          onHide: () => _hideTweet(tweet),
          onReply: (reply) => _replyToTweet(tweet, reply),
          onBookmark: () => _toggleBookmark(tweet),
        )).toList(),
      ),
    );
  }
}

class Tweet {
  final String userShortName;
  final String userLongName;
  final DateTime timestamp;
  final String description;
  final String imagePath;
  int numComments;
  int numRetweets;
  int numLikes;
  bool isLiked = false;
  bool isRetweeted = false;
  bool isBookmarked = false;

  Tweet({
    required this.userShortName,
    required this.userLongName,
    required this.timestamp,
    required this.description,
    required this.imagePath,
    required this.numComments,
    required this.numRetweets,
    required this.numLikes,
  });
}

class TweetWidget extends StatelessWidget {
  final Tweet tweet;
  final VoidCallback onLike;
  final VoidCallback onRetweet;
  final VoidCallback onHide;
  final ValueChanged<String> onReply;
  final VoidCallback onBookmark;

  const TweetWidget({
    required this.tweet,
    required this.onLike,
    required this.onRetweet,
    required this.onHide,
    required this.onReply,
    required this.onBookmark,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(tweet.imagePath),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(tweet.userLongName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    Text('@${tweet.userShortName}'),
                    const SizedBox(width: 5),
                    Text('· ${tweet.timestamp.hour}:${tweet.timestamp.minute}'),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.expand_more),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Hide Tweet'),
                            content: const Text('Do you want to hide this tweet?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  onHide();
                                  Navigator.pop(context);
                                },
                                child: const Text('Hide'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(tweet.description),
                const SizedBox(height: 5),
                if (tweet.imagePath.isNotEmpty) Image.asset(tweet.imagePath),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(tweet.isLiked ? Icons.favorite : Icons.favorite_border),
                          onPressed: onLike,
                        ),
                        Text('${tweet.numLikes}'),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(tweet.isRetweeted ? Icons.repeat : Icons.repeat_outlined),
                          onPressed: onRetweet,
                        ),
                        Text('${tweet.numRetweets}'),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_outline),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReplyPage(
                              onSubmit: (reply) => onReply(reply),
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(tweet.isBookmarked ? Icons.bookmark : Icons.bookmark_border),
                      onPressed: onBookmark,
                    ),
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

class NewTweetPage extends StatefulWidget {
  final ValueChanged<Tweet> onSubmit;

  const NewTweetPage({required this.onSubmit, super.key});

  @override
  _NewTweetPageState createState() => _NewTweetPageState();
}

class _NewTweetPageState extends State<NewTweetPage> {
  final TextEditingController _userShortNameController = TextEditingController();
  final TextEditingController _userLongNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imagePathController = TextEditingController();

  void _submit() {
    final tweet = Tweet(
      userShortName: _userShortNameController.text,
      userLongName: _userLongNameController.text,
      timestamp: DateTime.now(),
      description: _descriptionController.text,
      imagePath: _imagePathController.text,
      numComments: 0,
      numRetweets: 0,
      numLikes: 0,
    );
    widget.onSubmit(tweet);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Tweet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _userShortNameController,
              decoration: const InputDecoration(labelText: 'Short Name'),
            ),
            TextField(
              controller: _userLongNameController,
              decoration: const InputDecoration(labelText: 'Long Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Tweet Text'),
            ),
            TextField(
              controller: _imagePathController,
              decoration: const InputDecoration(labelText: 'Image Path (optional)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class ReplyPage extends StatefulWidget {
  final ValueChanged<String> onSubmit;

  const ReplyPage({required this.onSubmit, super.key});

  @override
  _ReplyPageState createState() => _ReplyPageState();
}

class _ReplyPageState extends State<ReplyPage> {
  final TextEditingController _replyController = TextEditingController();

  void _submit() {
    widget.onSubmit(_replyController.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reply'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _replyController,
              decoration: const InputDecoration(labelText: 'Reply Text'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}