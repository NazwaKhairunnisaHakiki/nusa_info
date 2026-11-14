import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/post_service.dart';
import 'detail_screen.dart';
import 'add_post_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PostService _postService = PostService();

  late Future<List<Post>> _postsFuture;

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
    _postsFuture = _postService.fetchPosts();
  }

  Map<String, String> _announcementFor(Post post) {
    return _announcements[(post.id - 1) % _announcements.length];
  }

  Future<void> _refreshPosts() async {
    final future = _postService.fetchPosts();

    setState(() {
      _postsFuture = future;
    });

    try {
      await future;
    } catch (_) {
      // Error is displayed by FutureBuilder.
    }
  }

  Future<void> _openAddPost() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const AddPostScreen()),
    );

    if (!mounted) return;

    if (result == true) {
      setState(() {
        _postsFuture = _postService.fetchPosts();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Announcement successfully created!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _openDetail(Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailScreen(post: post)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NusaInfo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _openAddPost,
            icon: const Icon(Icons.add),
            tooltip: 'Add Announcement',
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text(
                      'Failed to load announcements.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please check your internet connection.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _postsFuture = _postService.fetchPosts();
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          final posts = snapshot.data ?? [];

          return RefreshIndicator(
            onRefresh: _refreshPosts,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                final announcement = _announcementFor(post);

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        '${post.id}',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      announcement['title']!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        announcement['body']!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _openDetail(post),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
