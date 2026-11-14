import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/post_service.dart';

class DetailScreen extends StatefulWidget {
  final Post post;

  const DetailScreen({super.key, required this.post});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final PostService _postService = PostService();

  late Future<List<Map<String, dynamic>>> _commentsFuture;

  final List<Map<String, String>> _announcements = [
    {
      'title': 'Upcoming Technology Seminar',
      'body':
          'Join our technology seminar to explore the latest '
          'innovations in artificial intelligence, digital technology, '
          'and software development. All students are welcome.',
    },
    {
      'title': 'Campus Orientation Program',
      'body':
          'New students are invited to attend the campus orientation '
          'program. Get to know the university, meet new friends, '
          'and learn about student activities.',
    },
    {
      'title': 'Student Achievement Awards',
      'body':
          'Congratulations to all students who have achieved '
          'outstanding results in academic and non-academic competitions. '
          'Keep up the excellent work!',
    },
    {
      'title': 'Free English Workshop',
      'body':
          'Improve your English communication skills through '
          'our free workshop. Participants will practice speaking, '
          'writing, and everyday conversations.',
    },
    {
      'title': 'Digital Innovation Competition',
      'body':
          'Show your creativity by joining our digital innovation '
          'competition. Develop an interesting idea and present '
          'your solution to real-world problems.',
    },
    {
      'title': 'Library Service Information',
      'body':
          'The university library is open for all students. '
          'Visit the library to access books, learning materials, '
          'and digital academic resources.',
    },
    {
      'title': 'Student Community Gathering',
      'body':
          'Meet fellow students and build new connections '
          'at our community gathering. Enjoy an exciting day '
          'filled with activities and collaboration.',
    },
    {
      'title': 'Scholarship Application Notice',
      'body':
          'Students can now prepare their documents for the '
          'upcoming scholarship application. Please check the '
          'official requirements before submitting your application.',
    },
    {
      'title': 'Environmental Awareness Campaign',
      'body':
          'Take part in our environmental campaign. '
          'Together, we can create a cleaner campus through '
          'recycling and sustainable daily habits.',
    },
    {
      'title': 'Career Preparation Workshop',
      'body':
          'Prepare for your future career by joining our workshop. '
          'Learn how to write a professional CV, prepare for interviews, '
          'and build your career opportunities.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _commentsFuture = _postService.fetchComments(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final announcement = _announcements[(post.id - 1) % _announcements.length];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcement Details'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      announcement['title']!,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Announcement ID: ${post.id}',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text('User ID: ${post.userId}'),
                    const Divider(height: 24),
                    const Text(
                      'Announcement Content',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      announcement['body']!,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Comments',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _commentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Failed to load comments. '
                        'Please check your internet connection.',
                      ),
                    ),
                  );
                }

                final comments = snapshot.data ?? [];

                if (comments.isEmpty) {
                  return const Text('No comments yet.');
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(
                          comment['name']?.toString() ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment['email']?.toString() ?? '',
                              style: const TextStyle(color: Colors.blue),
                            ),
                            const SizedBox(height: 6),
                            Text(comment['body']?.toString() ?? ''),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
