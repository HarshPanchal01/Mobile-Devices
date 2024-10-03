import 'package:flutter/material.dart';
import 'tweet_model.dart';

// ReplyPage class
class ReplyPage extends StatefulWidget {
  final Tweet originalTweet;
  final ValueChanged<Tweet> onSubmit;

  const ReplyPage({
    required this.originalTweet,
    required this.onSubmit,
    super.key,
  });
  // Create a state
  @override
  _ReplyPageState createState() => _ReplyPageState();
}

class _ReplyPageState extends State<ReplyPage> {
  // Text editing controllers
  final TextEditingController _userShortNameController = TextEditingController();
  final TextEditingController _userLongNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imagePathController = TextEditingController();
  final TextEditingController _profileImagePathController = TextEditingController();

  // Submit reply function
  void _submitReply() {
    final reply = Tweet(
      userShortName: _userShortNameController.text,
      userLongName: _userLongNameController.text,
      timestamp: DateTime.now(),
      description: _descriptionController.text,
      imagePath: _imagePathController.text, // Can be empty
      profileImagePath: _profileImagePathController.text, // Can be empty
      numComments: 0,
      numRetweets: 0,
      numLikes: 0,
    );
    widget.onSubmit(reply);
    Navigator.pop(context);
  }

  // Build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reply to Tweet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _submitReply, // Use the same submit function
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Replying to @${widget.originalTweet.userShortName}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _userShortNameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _userLongNameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Reply Content'),
            ),
            TextField(
              controller: _imagePathController,
              decoration: const InputDecoration(labelText: 'Image Path/URL (optional)'),
            ),
            TextField(
              controller: _profileImagePathController,
              decoration: const InputDecoration(labelText: 'Profile Image Path/URL (optional)'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitReply,
        child: const Icon(Icons.send),
      ),
    );
  }
}
