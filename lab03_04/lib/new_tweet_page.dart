import 'package:flutter/material.dart';
import 'tweet_model.dart';

// NewTweetPage class
class NewTweetPage extends StatefulWidget {
  final ValueChanged<Tweet> onSubmit; // Changed to accept a Tweet object

  const NewTweetPage({required this.onSubmit, super.key});
  // Create a state
  @override
  _NewTweetPageState createState() => _NewTweetPageState();
}

class _NewTweetPageState extends State<NewTweetPage> {
  // Text editing controllers
  final TextEditingController _userShortNameController = TextEditingController();
  final TextEditingController _userLongNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imagePathController = TextEditingController();
  final TextEditingController _profileImagePathController = TextEditingController();

  // Submit function
  void _submit() {
    final tweet = Tweet(
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
    widget.onSubmit(tweet);
    Navigator.pop(context);
  }

  // Build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Tweet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _submit,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
              decoration: const InputDecoration(labelText: 'Tweet Content'),
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
    );
  }
}
