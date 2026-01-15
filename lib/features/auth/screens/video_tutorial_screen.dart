import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoTutorialScreen extends StatefulWidget {
  const VideoTutorialScreen({super.key});

  @override
  State<VideoTutorialScreen> createState() => _VideoTutorialScreenState();
}

class _VideoTutorialScreenState extends State<VideoTutorialScreen> {
  VideoPlayerController? _controller;
  bool _isPlaying = false;
  bool _isInitialized = false;
  Map<String, dynamic>? _selectedVideo;

  final List<Map<String, dynamic>> _videos = [
    {
      'title': 'Flutter Video Tutorial - Getting Started',
      'url':
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      'duration': '2:30',
      'views': '1.2K views',
      'time': '2 days ago',
      'description':
          'Learn Flutter from scratch with this comprehensive tutorial series.',
    },
    {
      'title': 'Building Your First Flutter App',
      'url':
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4', // Same for demo
      'duration': '5:15',
      'views': '856 views',
      'time': '1 week ago',
      'description':
          'Step-by-step guide to creating your first Flutter application.',
    },
    {
      'title': 'State Management in Flutter',
      'url':
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4', // Same for demo
      'duration': '8:45',
      'views': '2.1K views',
      'time': '3 days ago',
      'description':
          'Understanding state management patterns in Flutter development.',
    },
    {
      'title': 'Flutter Widgets Deep Dive',
      'url':
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4', // Same for demo
      'duration': '12:20',
      'views': '3.4K views',
      'time': '5 days ago',
      'description': 'Explore the most important widgets in Flutter.',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Start with no video selected - show list
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _selectVideo(Map<String, dynamic> video) {
    setState(() {
      _selectedVideo = video;
      _isInitialized = false;
      _isPlaying = false;
    });

    _controller?.dispose();
    _controller = VideoPlayerController.networkUrl(Uri.parse(video['url']))
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
      });

    _controller!.addListener(() {
      setState(() {
        _isPlaying = _controller!.value.isPlaying;
      });
    });
  }

  void _goBackToList() {
    setState(() {
      _selectedVideo = null;
      _controller?.pause();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedVideo == null) {
      return _buildVideoList();
    } else {
      return _buildVideoPlayer();
    }
  }

  Widget _buildVideoList() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Tutorials"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: _videos.length,
        itemBuilder: (context, index) {
          final video = _videos[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Container(
                width: 100,
                height: 60,
                color: Colors.grey[300],
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                      size: 30,
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        color: Colors.black.withOpacity(0.7),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        child: Text(
                          video['duration'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              title: Text(
                video['title'],
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text("${video['views']} • ${video['time']}"),
              onTap: () => _selectVideo(video),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Tutorial"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBackToList,
        ),
      ),
      body: Column(
        children: [
          // Video Player Section
          Container(
            color: Colors.black,
            height: 250,
            child: _isInitialized && _controller != null
                ? AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        VideoPlayer(_controller!),
                        // Play/Pause Overlay
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_isPlaying) {
                                _controller!.pause();
                              } else {
                                _controller!.play();
                              }
                            });
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Center(
                              child: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 60,
                              ),
                            ),
                          ),
                        ),
                        // Progress Bar
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: VideoProgressIndicator(
                            _controller!,
                            allowScrubbing: true,
                            colors: const VideoProgressColors(
                              playedColor: Colors.red,
                              bufferedColor: Colors.grey,
                              backgroundColor: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
          ),

          // Video Info Section (YouTube-like)
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video Title
                    Text(
                      _selectedVideo!['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Views and Date
                    Row(
                      children: [
                        Text(
                          _selectedVideo!['views'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _selectedVideo!['time'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Action Buttons (Like, Dislike, Share, etc.)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(Icons.thumb_up, "1.2K"),
                        _buildActionButton(Icons.thumb_down, "12"),
                        _buildActionButton(Icons.share, "Share"),
                        _buildActionButton(Icons.download, "Download"),
                        _buildActionButton(Icons.playlist_add, "Save"),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Channel Info
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Flutter Tutorials",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "1.5M subscribers",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Subscribe"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Description
                    Text(
                      _selectedVideo!['description'],
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),

                    // Comments Section
                    const Text(
                      "Comments",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Sample Comments
                    _buildComment(
                      "John Doe",
                      "Great tutorial! Very helpful for beginners.",
                      "2 hours ago",
                    ),
                    _buildComment(
                      "Jane Smith",
                      "Thanks for the clear explanation!",
                      "5 hours ago",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        IconButton(onPressed: () {}, icon: Icon(icon), color: Colors.grey[600]),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildComment(String author, String comment, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(radius: 16, child: Icon(Icons.person, size: 16)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      author,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
