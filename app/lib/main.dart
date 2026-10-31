import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const PrashiApp());
}

const purple = Color(0xFF9B5CFF);
const bg = Color(0xFF101014);
const panel = Color(0xFF1D1D25);

class PrashiApp extends StatelessWidget {
  const PrashiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prashi Toon Editor',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.dark(primary: purple),
      ),
      home: const EditorHome(),
    );
  }
}

class EditorHome extends StatefulWidget {
  const EditorHome({super.key});

  @override
  State<EditorHome> createState() => _EditorHomeState();
}

class _EditorHomeState extends State<EditorHome> {
  VideoPlayerController? controller;
  bool loading = false;

  Future<void> pickVideo() async {
    final picker = ImagePicker();

    final file = await picker.pickVideo(
      source: ImageSource.gallery,
    );

    if (file == null) return;

    setState(() => loading = true);

    try {
      await controller?.dispose();

      final newController =
          VideoPlayerController.file(File(file.path));

      await newController.initialize();

      if (!mounted) {
        await newController.dispose();
        return;
      }

      setState(() {
        controller = newController;
        loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video नहीं खुला: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final video = controller;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Prashi Toon Editor',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: panel,
        actions: [
          IconButton(
            onPressed: pickVideo,
            icon: const Icon(Icons.video_library),
            tooltip: 'Gallery',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: loading
                  ? const CircularProgressIndicator()
                  : video != null && video.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: video.value.aspectRatio,
                          child: VideoPlayer(video),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.movie_creation_outlined,
                              size: 85,
                              color: purple,
                            ),
                            SizedBox(height: 15),
                            Text(
                              'अपना वीडियो चुनें',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Gallery से वीडियो लाने के लिए नीचे दबाएँ',
                              style: TextStyle(color: Colors.white60),
                            ),
                          ],
                        ),
            ),
          ),
          if (video != null && video.value.isInitialized)
            VideoProgressIndicator(
              video,
              allowScrubbing: true,
              padding: const EdgeInsets.all(12),
            ),
          Container(
            color: panel,
            padding: const EdgeInsets.all(18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: pickVideo,
                  icon: const Icon(Icons.video_library),
                  label: const Text('Video चुनें'),
                ),
                if (video != null && video.value.isInitialized)
                  IconButton(
                    iconSize: 42,
                    color: purple,
                    onPressed: () {
                      setState(() {
                        video.value.isPlaying
                            ? video.pause()
                            : video.play();
                      });
                    },
                    icon: Icon(
                      video.value.isPlaying
                          ? Icons.pause_circle
                          : Icons.play_circle,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

