// Simple model class for a tweet
class Tweet {
  final String userShortName;
  final String userLongName;
  final DateTime timestamp;
  final String description;
  final String imagePath; // Optional
  final String profileImagePath; // Optional
  int numComments;
  int numRetweets;
  int numLikes;
  // Additional properties
  bool isLiked = false;
  bool isRetweeted = false;
  bool isBookmarked = false;
  // Constructor
  Tweet({
    required this.userShortName,
    required this.userLongName,
    required this.timestamp,
    required this.description,
    this.imagePath = '', // Default to empty string
    this.profileImagePath = '', // Default to empty string
    this.numComments = 0,
    this.numRetweets = 0,
    this.numLikes = 0,
  });
}
