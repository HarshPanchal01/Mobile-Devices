import 'package:flutter/material.dart';
import 'tweet_model.dart';
import 'reply_page.dart';

// TweetWidget class
class TweetWidget extends StatelessWidget {
  final Tweet tweet;
  final VoidCallback onLike;
  final VoidCallback onRetweet;
  final VoidCallback onHide;
  final ValueChanged<Tweet> onReply; // Changed to accept a Tweet object
  final VoidCallback onBookmark;
  // Constructor
  const TweetWidget({
    required this.tweet,
    required this.onLike,
    required this.onRetweet,
    required this.onHide,
    required this.onReply,
    required this.onBookmark,
    super.key,
  });

  // Method to calculate time difference
  String _timeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d'; // Show days
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h'; // Show hours
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m'; // Show minutes
    } else {
      return 'just now';
    }
  }

  // Build method
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: tweet.profileImagePath.isNotEmpty
                ? (tweet.profileImagePath.startsWith('http')
                    ? NetworkImage(tweet.profileImagePath)
                    : AssetImage(tweet.profileImagePath) as ImageProvider)
                    : AssetImage('assets/profile2.png'), // Default image
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
                    Text('· ${_timeAgo(tweet.timestamp)}'), // Time ago logic used here
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
                if (tweet.imagePath.isNotEmpty) 
                  Image(
                    image: tweet.imagePath.startsWith('http')
                        ? NetworkImage(tweet.imagePath)
                        : AssetImage(tweet.imagePath) as ImageProvider,
                  ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.comment),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReplyPage(
                                  originalTweet: tweet,
                                  onSubmit: onReply,
                                ),
                              ),
                            );
                          },
                        ),
                        Text('${tweet.numComments}'),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: Icon(tweet.isLiked ? Icons.favorite : Icons.favorite_border),
                          onPressed: onLike,
                        ),
                        Text('${tweet.numLikes}'),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: Icon(tweet.isRetweeted ? Icons.repeat : Icons.repeat_outlined),
                          onPressed: onRetweet,
                        ),
                        Text('${tweet.numRetweets}'),
                      ],
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
