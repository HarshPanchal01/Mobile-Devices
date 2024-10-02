import 'package:flutter/material.dart';
import 'tweet_model.dart';
import 'tweet_widget.dart';
import 'new_tweet_page.dart';

// MyHomePage class
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  // Create a state
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // List of tweets
  final List<Tweet> tweets = [
    Tweet(
      userShortName: 'JohnnyTheGoat',
      userLongName: 'John Smith',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      description: 'This is a sample tweet description.',
      imagePath: 'assets/image1.png',
      profileImagePath: 'assets/profile1.png',
      numComments: 11,
      numRetweets: 57,
      numLikes: 200,
    ),
    Tweet(
      userShortName: 'TwitterFanboy',
      userLongName: 'Im him',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      description: 'Another sample tweet description.',
      imagePath: 'assets/image2.png',
      profileImagePath: 'assets/profile2.png',
      numComments: 42,
      numRetweets: 750,
      numLikes: 2500,
    ),
  ];

  // Functions to handle tweet interactions
  void _addTweet(Tweet tweet) {
    setState(() {
      tweets.insert(0, tweet);
    });
  }

  // Toggle like function
  void _toggleLike(Tweet tweet) {
    setState(() {
      tweet.isLiked = !tweet.isLiked;
      tweet.numLikes += tweet.isLiked ? 1 : -1;
    });
  }

  // Toggle retweet function
  void _toggleRetweet(Tweet tweet) {
    setState(() {
      tweet.isRetweeted = !tweet.isRetweeted;
      tweet.numRetweets += tweet.isRetweeted ? 1 : -1;
    });
  }

  // Hide tweet function
  void _hideTweet(Tweet tweet) {
    setState(() {
      tweets.remove(tweet);
    });
  }

  // Reply to tweet function
  void _replyToTweet(Tweet originalTweet, Tweet reply) {
    setState(() {
      // Increment the number of comments for the original tweet
      originalTweet.numComments += 1;
      // Insert the reply after the original tweet
      tweets.insert(tweets.indexOf(originalTweet) + 1, reply);
    });
  }

  // Toggle bookmark function
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

  // Build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Twitter Clone'),
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
