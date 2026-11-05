import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ffmpeg_kit_flutter_new/ffprobe_kit.dart';

const purple = Color(0xFF8B5CF6);
const appBlack = Color(0xFF09090B);
const appWhite = Color(0xFFFFFFFF);
const softGrey = Color(0xFFF3F2F7);
const muted = Color(0xFF777482);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  runApp(const AmCutApp());
}

class AmCutApp extends StatelessWidget {
  const AmCutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AmCut',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: appWhite,
        colorScheme: ColorScheme.fromSeed(
          seedColor: purple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0;

  Future<void> newProject() async {
    final picker = ImagePicker();
    final file = await picker.pickVideo(source: ImageSource.gallery);
    if (file == null || !mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditorScreen(videoPath: file.path),
      ),
    );
  }

  void showComingSoon(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name feature will be added in a future update.')),
    );
  }

  Widget sectionTitle(String title, {String? action, VoidCallback? onAction}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.w800, color: appBlack,
        )),
        if (action != null)
          TextButton(
            onPressed: onAction,
            child: Text(action, style: const TextStyle(color: purple)),
          ),
      ],
    );
  }

  Widget toolTile(IconData icon, String label, {VoidCallback? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap ?? () => showComingSoon(label),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              color: const Color(0xFFF0EAFE),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(icon, color: purple, size: 27),
          ),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: appBlack,
              fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget homeBody() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 22),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: appBlack,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('MAKE EVERY MOMENT',
                style: TextStyle(color: Colors.white70, letterSpacing: 2,
                  fontSize: 10, fontWeight: FontWeight.w700)),
              const SizedBox(height: 9),
              const Text('Create something\namazing.',
                style: TextStyle(color: Colors.white, fontSize: 27,
                  height: 1.12, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              SizedBox(
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: newProject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple, foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13)),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('New Project',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        sectionTitle('Quick Tools'),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            toolTile(Icons.content_cut, 'AutoCut'),
            toolTile(Icons.closed_caption, 'AI Captions'),
            toolTile(Icons.auto_awesome, 'AI Effects'),
            toolTile(Icons.layers_outlined, 'Overlay'),
          ],
        ),
        const SizedBox(height: 24),
        sectionTitle('AI Studio', action: 'See all',
          onAction: () => showComingSoon('AI Studio')),
        const SizedBox(height: 13),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 17,
          crossAxisSpacing: 8,
          childAspectRatio: 0.82,
          children: [
            toolTile(Icons.person_remove_alt_1, 'Remove BG'),
            toolTile(Icons.video_library_outlined, 'Templates'),
            toolTile(Icons.face_retouching_natural, 'Beauty'),
            toolTile(Icons.hd_outlined, 'Enhance'),
          ],
        ),
        const SizedBox(height: 23),
        sectionTitle('Editing Studio'),
        const SizedBox(height: 12),
        InkWell(
          onTap: newProject,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: softGrey,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE8E5EF)),
            ),
            child: Row(
              children: [
                Container(
                  height: 48, width: 48,
                  decoration: BoxDecoration(
                    color: purple, borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.movie_creation_outlined,
                    color: Colors.white, size: 26),
                ),
                const SizedBox(width: 13),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Start Editing',
                        style: TextStyle(fontWeight: FontWeight.bold,
                          color: appBlack, fontSize: 15)),
                      SizedBox(height: 4),
                      Text('Choose a video from your Gallery',
                        style: TextStyle(color: muted, fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 17, color: purple),
              ],
            ),
          ),
        ),
      ],
    );
  }
          Widget simplePage(String title, String subtitle, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: purple, size: 54),
          const SizedBox(height: 14),
          Text(title, style: const TextStyle(fontSize: 21,
            fontWeight: FontWeight.bold, color: appBlack)),
          const SizedBox(height: 7),
          Text(subtitle, textAlign: TextAlign.center,
            style: const TextStyle(color: muted)),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      homeBody(),
      simplePage('Templates', 'Video templates will appear here.', Icons.video_library_outlined),
      const SizedBox.shrink(),
      simplePage('Projects', 'Your saved editing projects will appear here.', Icons.folder_open_outlined),
      simplePage('Me', 'AmCut account and settings.', Icons.person_outline),
    ];

    return Scaffold(
      backgroundColor: appWhite,
      appBar: AppBar(
        backgroundColor: appWhite,
        surfaceTintColor: appWhite,
        elevation: 0,
        titleSpacing: 18,
        title: const Row(children: [
          Icon(Icons.movie_creation, color: purple, size: 27),
          SizedBox(width: 9),
          Text('AmCut', style: TextStyle(color: appBlack,
            fontWeight: FontWeight.w900, letterSpacing: 0.3)),
        ]),
        actions: [
          IconButton(
            onPressed: () => showComingSoon('Notifications'),
            icon: const Icon(Icons.notifications_none, color: appBlack),
          ),
          IconButton(
            onPressed: () => showComingSoon('Settings'),
            icon: const Icon(Icons.settings_outlined, color: appBlack),
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: SafeArea(child: pages[selectedTab]),
      bottomNavigationBar: Container(
        color: appBlack,
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 66,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(Icons.home_outlined, 'Home', 0),
                _navItem(Icons.video_library_outlined, 'Templates', 1),
                InkWell(
                  onTap: newProject,
                  child: Container(
                    height: 48, width: 52,
                    decoration: BoxDecoration(
                      color: purple, borderRadius: BorderRadius.circular(15)),
                    child: const Icon(Icons.add, color: Colors.white, size: 30),
                  ),
                ),
                _navItem(Icons.folder_outlined, 'Projects', 3),
                _navItem(Icons.person_outline, 'Me', 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final active = selectedTab == index;
    return InkWell(
      onTap: () => setState(() => selectedTab = index),
      child: SizedBox(
        width: 66,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: active ? purple : Colors.white70, size: 22),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(fontSize: 9,
            color: active ? purple : Colors.white70,
            fontWeight: active ? FontWeight.bold : FontWeight.normal)),
        ]),
      ),
    );
  }
}

class EditorScreen extends StatefulWidget {
  final String videoPath;

  const EditorScreen({super.key, required this.videoPath});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late final Player player;
  late final VideoController videoController;

  bool loading = true;
  String? errorMessage;
  int selectedTool = 0;
double _videoScale = 1.0;
double _startScale = 1.0;

Offset _videoOffset = Offset.zero;
Offset _startOffset = Offset.zero;
  String selectedRatioName = 'Original';
  double? selectedRatio;

  final List<Map<String, dynamic>> ratios = [
    {'name': 'Original', 'ratio': null},
    {'name': '9:16', 'ratio': 9 / 16},
    {'name': '16:9', 'ratio': 16 / 9},
    {'name': '1:1', 'ratio': 1.0},
    {'name': '4:3', 'ratio': 4 / 3},
    {'name': '2:1', 'ratio': 2.0},
  ];

  final tools = const [
    ['Edit', Icons.content_cut],
    ['Audio', Icons.music_note],
    ['Text', Icons.text_fields],
    ['Effects', Icons.auto_awesome],
    ['Overlay', Icons.layers],
    ['Captions', Icons.closed_caption],
    ['Filters', Icons.tune],
    ['Export', Icons.file_upload],
  ];

  @override
  void initState() {
    super.initState();
    player = Player();
    videoController = VideoController(player);
    initializeVideo();
  }

  Future<void> initializeVideo() async {
    try {
      await player.open(Media(widget.videoPath), play: false);
      if (!mounted) return;
      setState(() {
        loading = false;
        errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loading = false;
        errorMessage = 'Video खुल नहीं पाया: $e';
      });
    }
  }

  String timeText(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF303030),
      ),
    );
  }

  void showRatioOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF202020),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Video Ratio',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: ratios.map((item) {
                  final name = item['name'] as String;
                  final selected = selectedRatioName == name;

                  return ChoiceChip(
                    label: Text(name),
                    selected: selected,
                    selectedColor: const Color(0xFF00C8E8),
                    backgroundColor: const Color(0xFF383838),
                    labelStyle: TextStyle(
                      color: selected ? Colors.black : Colors.white,
                    ),
                    onSelected: (value) {
                      if (!value) return;
                      setState(() {
                        selectedRatioName = name;
                        selectedRatio = item['ratio'] as double?;
                      });
                      Navigator.pop(sheetContext);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showTool(String name) {
    if (name == 'Export') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ExportScreen(videoPath: widget.videoPath),
        ),
      );
      return;
    }

    final details = <String, List<String>>{
      'Edit': ['Trim', 'Split', 'Crop', 'Rotate', 'Speed', 'Reverse'],
      'Audio': ['Add music', 'Sound effects', 'Voiceover'],
      'Text': ['Add text', 'Text styles', 'Text animation'],
      'Effects': ['Video effects', 'Body effects', 'Light effects'],
      'Overlay': ['Add overlay', 'Picture in picture'],
      'Captions': ['Auto captions', 'Caption styles'],
      'Filters': ['Color filters', 'Adjust'],
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF202020),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              ...(details[name] ?? ['Coming soon']).map(
                (item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.circle,
                    size: 8,
                    color: Color(0xFF00C8E8),
                  ),
                  title: Text(
                    item,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    showMessage('$item अभी उपलब्ध नहीं है।');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget timelineTrack({
    required IconData icon,
    required String title,
    required Color color,
    required String label,
    required VoidCallback onAdd,
  }) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          SizedBox(
            width: 75,
            child: Row(
              children: [
                Icon(icon, color: Colors.white70, size: 16),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 34,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onAdd,
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.white70,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 30,
                    minHeight: 35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget videoTimeline() {
    return Container(
      height: 205,
      color: const Color(0xFF171717),
      padding: const EdgeInsets.fromLTRB(12, 9, 12, 5),
      child: Column(
        children: [
          Row(
            children: [
              
              StreamBuilder<Duration>(
                stream: player.stream.position,
                initialData: Duration.zero,
                builder: (context, snapshot) {
                  return Text(
                    timeText(snapshot.data ?? Duration.zero),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  );
                },
              ),
              const Text(
                ' / ',
                style: TextStyle(color: Colors.white54),
              ),
              StreamBuilder<Duration>(
                stream: player.stream.duration,
                initialData: Duration.zero,
                builder: (context, snapshot) {
                  return Text(
                    timeText(snapshot.data ?? Duration.zero),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 9),

          // Video clip strip
          SizedBox(
            height: 52,
            child: Row(
              children: [
                const SizedBox(
                  width: 75,
                  child: Row(
                    children: [
                      Icon(Icons.movie, color: Colors.white70, size: 16),
                      SizedBox(width: 5),
                      Text(
                        'Video',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF353535),
                      border: Border.all(
                        color: const Color(0xFF00C8E8),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Row(
                        children: List.generate(
                          7,
                          (index) => Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: index.isEven
                                    ? const Color(0xFF555555)
                                    : const Color(0xFF414141),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.white24,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          timelineTrack(
            icon: Icons.music_note,
            title: 'Audio',
            color: const Color(0xFF286C58),
            label: ' + Add audio',
            onAdd: () => showTool('Audio'),
          ),
          timelineTrack(
            icon: Icons.text_fields,
            title: 'Text',
            color: const Color(0xFF66512D),
            label: ' + Add text',
            onAdd: () => showTool('Text'),
          ),
          const Spacer(),
          const Text(
            'Timeline editing controls will be added separately.',
            style: TextStyle(color: Colors.white38, fontSize: 9),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top toolbar
            Container(
              height: 48,
              color: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () => showMessage('Search अभी उपलब्ध नहीं है।'),
                    icon: const Icon(Icons.search, color: Colors.white),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => showMessage('AI UHD अभी उपलब्ध नहीं है।'),
                    icon: const Icon(
                      Icons.hd,
                      color: Colors.white,
                      size: 19,
                    ),
                    label: const Text(
                      'AI UHD',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 4),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExportScreen(
                            videoPath: widget.videoPath,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C8E8),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      minimumSize: const Size(0, 34),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: const Text(
                      'Export',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ),

            // Video preview
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                color: selectedRatio == null
              ? Colors.black
                : const Color(0xFF171717),
                child: Center(
  child: loading
      ? const CircularProgressIndicator(
          color: Color(0xFF00C8E8),
        )
      : errorMessage != null
          ? Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            )
          : GestureDetector(
    behavior: HitTestBehavior.opaque,
    onScaleStart: (details) {
      _startScale = _videoScale;
      _startOffset = _videoOffset;
    },
    onScaleUpdate: (details) {
      setState(() {
        _videoScale = (_startScale * details.scale)
            .clamp(1.0, 4.0)
            .toDouble();

        _videoOffset =
            _startOffset + details.focalPointDelta;
      });
    },
    child: ClipRect(
  child: selectedRatio == null
      ? Transform.translate(
          offset: _videoOffset,
          child: Transform.scale(
            scale: _videoScale,
            child: Video(
              controller: videoController,
              fit: BoxFit.contain,
              controls: NoVideoControls,
            ),
          ),
        )
      : AspectRatio(
          aspectRatio: selectedRatio!,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(color: Colors.black),
              Transform.translate(
                offset: _videoOffset,
                child: Transform.scale(
                  scale: _videoScale,
                  child: Video(
                    controller: videoController,
                    fit: BoxFit.contain,
                    controls: NoVideoControls,
                  ),
                ),
              ),
            ],
          ),
        ),
),
              ),
            ),
          ),
 // Playback controls
Container(
  height: 48,
  color: const Color(0xFF171717),
  padding: const EdgeInsets.symmetric(horizontal: 10),
  child: Row(
    children: [
      const SizedBox(width: 56),

      // Center Play/Pause button
      Expanded(
        child: Center(
          child: StreamBuilder<bool>(
            stream: player.stream.playing,
            initialData: false,
            builder: (context, snapshot) {
              final playing = snapshot.data ?? false;

              return GestureDetector(
                onTap: () {
                  if (playing) {
                    player.pause();
                  } else {
                    player.play();
                  }
                },
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF3030),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    playing ? Icons.pause : Icons.play_arrow,
                    color: Colors.black,
                    size: 23,
                  ),
                ),
              );
            },
          ),
        ),
      ),

      const SizedBox(width: 8),

      Container(
  width: 38,
  height: 34,
  decoration: BoxDecoration(
    color: const Color(0xFF777777),
    borderRadius: BorderRadius.circular(9),
  ),
  child: Center(
    child: Container(
      width: 30,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(7),
      ),
      child: IconButton(
        onPressed: showRatioOptions,
        padding: EdgeInsets.zero,
        icon: const Icon(
          Icons.crop_free,
          color: Colors.white,
          size: 21,
        ),
      ),
    ),
  ),
),
    ],
  ),
),
            // Timeline
            videoTimeline(),

            // Bottom editing toolbar
            Container(
              height: 82,
              color: Colors.black,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tools.length,
                itemBuilder: (context, index) {
                  final item = tools[index];
                  final active = selectedTool == index;

                  return InkWell(
                    onTap: () {
                      setState(() => selectedTool = index);
                      showTool(item[0] as String);
                    },
                    child: SizedBox(
                      width: 76,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item[1] as IconData,
                            color: active
                                ? const Color(0xFF00C8E8)
                                : Colors.white,
                            size: 23,
                          ),
                          const SizedBox(height: 7),
                          Text(
                            item[0] as String,
                            style: TextStyle(
                              color: active
                                  ? const Color(0xFF00C8E8)
                                  : Colors.white70,
                              fontSize: 10,
                              fontWeight: active
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class ToolInfo extends StatelessWidget {
  final String title;
  final List<String> items;
  const ToolInfo({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 20,
            fontWeight: FontWeight.bold, color: appBlack)),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 9),
            child: Text(item, style: const TextStyle(color: appBlack)),
          )),
          const SizedBox(height: 15),
        ]),
      ),
    );
  }
}
class ExportScreen extends StatefulWidget {
  final String videoPath;

  const ExportScreen({
    super.key,
    required this.videoPath,
  });

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  bool isGif = false;
  bool aiUltraHD = false;
  bool opticalFlow = false;
  bool exporting = false;
  bool exportComplete = false;

  double progress = 0.01;
  String progressMessage = 'Preparing video...';
  String? exportError;

  int resolutionIndex = 2;
  int frameRateIndex = 2;
  int bitrateIndex = 1;
  int gifQualityIndex = 0;

  final resolutions = ['480p', '720p', '1080p', '2K', '4K'];
  final frameRates = ['24', '25', '30', '50', '60'];
  final bitrates = ['5', '10', '20', '50', '100'];
  final gifQualities = ['240P', '320P', '640P'];

  Widget topTab(String title, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 12,
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : Colors.white38,
              ),
            ),
            const SizedBox(height: 7),
            Container(
              height: 3,
              width: 43,
              decoration: BoxDecoration(
                color: selected ? purple : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        Flexible(
          child: Text(
            subtitle,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  Widget switchRow(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: purple,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget qualityCard(
    String quality,
    String description,
    bool selected,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 135,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF292929),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? Colors.white : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                quality,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(height: 1, color: Colors.white12),
              const SizedBox(height: 12),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sliderSection({
    required String title,
    required String subtitle,
    required int value,
    required List<String> labels,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle(title, subtitle),
        const SizedBox(height: 12),
        Slider(
          value: value.toDouble(),
          min: 0,
          max: (labels.length - 1).toDouble(),
          divisions: labels.length - 1,
          activeColor: purple,
          inactiveColor: Colors.white24,
          onChanged: (v) => onChanged(v.round()),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: labels.map(
            (label) => Text(
              label,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 12,
              ),
            ),
          ).toList(),
        ),
      ],
    );
  }

  String quotePath(String path) {
    return '"${path.replaceAll('"', '\\"')}"';
  }

  Future<double> getVideoDuration() async {
    try {
      final probe =
          await FFprobeKit.getMediaInformation(widget.videoPath);
      final info = probe.getMediaInformation();
      return (double.tryParse(info?.getDuration() ?? '') ?? 0) * 1000;
    } catch (_) {
      return 0;
    }
  }

  Widget shareOption({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 76,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 17),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  void showExportOptions() {
    if (exporting) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF191919),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Export',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      icon: const Icon(Icons.close, size: 29),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                shareOption(
                  icon: Icons.camera_alt,
                  title: 'Save and share to Instagram',
                  color: const Color(0xFFE1306C),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    startExport(shareAfter: true);
                  },
                ),
                const SizedBox(height: 12),
                shareOption(
                  icon: Icons.save_alt,
                  title: 'Save to device',
                  color: Colors.white,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    startExport();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
          Future<void> startExport({bool shareAfter = false}) async {
    if (exporting) return;

    setState(() {
      exporting = true;
      exportComplete = false;
      exportError = null;
      progress = 0.01;
      progressMessage = 'Preparing video...';
    });

    try {
      final directory = await getTemporaryDirectory();
      final stamp = DateTime.now().millisecondsSinceEpoch;

      final outputPath = isGif
          ? '${directory.path}/amcut_$stamp.gif'
          : '${directory.path}/amcut_$stamp.mp4';

      final totalDuration = await getVideoDuration();

      String command;

      if (isGif) {
        final sizes = [240, 320, 640];
        final size = sizes[gifQualityIndex];

        command =
            '-y -i ${quotePath(widget.videoPath)} '
            '-vf "fps=15,scale=$size:-1:flags=lanczos,'
            'split[s0][s1];[s0]palettegen[p];'
            '[s1][p]paletteuse" '
            '-loop 0 ${quotePath(outputPath)}';
      } else {
        final heights = [480, 720, 1080, 1440, 2160];
        final height = heights[resolutionIndex];
        final fps = frameRates[frameRateIndex];
        final bitrate = bitrates[bitrateIndex];

        final filters = <String>[
          "scale='if(gte(iw,ih),$height,-2)':'if(gte(iw,ih),-2,$height)':force_divisible_by=2",
          'fps=$fps',
        ];

        if (aiUltraHD) {
          filters.add('unsharp=5:5:0.8:3:3:0.4');
        }

        if (opticalFlow) {
          filters.add('minterpolate=fps=$fps');
        }

        command =
            '-y -i ${quotePath(widget.videoPath)} '
            '-vf "${filters.join(',')}" '
            '-c:v libx264 -preset ultrafast '
            '-threads 2 '
            '-b:v ${bitrate}M '
            '-maxrate ${bitrate}M '
            '-bufsize ${bitrate * 2}M '
            '-pix_fmt yuv420p '
            '-c:a aac -b:a 192k '
            '-movflags +faststart '
            '${quotePath(outputPath)}';
      }

      if (!mounted) return;

      setState(() => progressMessage = 'Exporting video...');

      final completer = Completer<dynamic>();

      await FFmpegKit.executeAsync(
        command,
        (session) {
          if (!completer.isCompleted) {
            completer.complete(session);
          }
        },
        null,
        (statistics) {
          if (!mounted || totalDuration <= 0) return;

          final processed = statistics.getTime().toDouble();
          final value =
              (processed / totalDuration).clamp(0.01, 0.99).toDouble();

          if (value > progress) {
            setState(() {
              progress = value;
              progressMessage = 'Exporting video...';
            });
          }
        },
      );

      final session = await completer.future;
      final returnCode = await session.getReturnCode();

      if (!ReturnCode.isSuccess(returnCode)) {
        final logs = await session.getAllLogsAsString();
        final fail = await session.getFailStackTrace();

        final details = (fail != null && fail.trim().isNotEmpty)
            ? fail
            : (logs != null && logs.trim().isNotEmpty)
                ? logs
                : 'FFmpeg export failed. Return code: $returnCode';

        throw Exception(details);
      }

      if (!mounted) return;

      setState(() {
        progress = 0.99;
        progressMessage = 'Saving to Gallery...';
      });

      final result = await SaverGallery.saveFile(
        filePath: outputPath,
        fileName: isGif ? 'AmCut_$stamp.gif' : 'AmCut_$stamp.mp4',
        skipIfExists: false,
        albumPath: 'AmCut',
      );

      if (shareAfter) {
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(outputPath)],
            text: 'Created with AmCut',
          ),
        );
      }

      if (!mounted) return;

      setState(() {
        progress = 1.0;
        exporting = false;
        exportComplete = true;
        progressMessage = 'Export Complete!';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gallery में सेव हो गया: ${result.savedUri ?? "Success"}',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        exporting = false;
        exportError = e.toString();
        progressMessage = 'Export failed';
      });
    }
  }

  Widget buildProgressScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  exportComplete
                      ? Icons.check_circle
                      : Icons.movie_creation_outlined,
                  color: purple,
                  size: 70,
                ),
                const SizedBox(height: 30),
                Text(
                  exportError != null
                      ? 'Export Failed'
                      : exportComplete
                          ? 'Export Complete!'
                          : 'Exporting...',
                  style: const TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 12),
                Text(
                  progressMessage,
                  style: const TextStyle(color: Colors.white60),
                ),
                const SizedBox(height: 35),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 190,
                      width: 190,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 9,
                        backgroundColor: Colors.white12,
                        valueColor: const AlwaysStoppedAnimation(purple),
                      ),
                    ),
                    Text(
                      '${(progress * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                if (exportComplete || exportError != null)
                  ElevatedButton(
                    onPressed: () {
                      if (exportComplete) {
                        Navigator.pop(context);
                      } else {
                        setState(() {
                          exportError = null;
                          progress = 0.01;
                          progressMessage = 'Ready to export';
                        });
                      }
                    },
                    child: Text(
                      exportComplete ? 'Done' : 'Back to settings',
                    ),
                  ),
                if (exportError != null) ...[
                  const SizedBox(height: 15),
                  Text(
                    exportError!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (exporting || exportComplete || exportError != null) {
      return buildProgressScreen();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF151515),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 5),
              child: Row(
                children: [
                  topTab('Video', !isGif, () {
                    setState(() => isGif = false);
                  }),
                  topTab('GIF', isGif, () {
                    setState(() => isGif = true);
                  }),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF303030),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Text('AI UHD'),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: showExportOptions,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purple,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Export'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 25),
                children: [
                  if (isGif) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: List.generate(3, (index) {
                        return qualityCard(
                          gifQualities[index],
                          ['Standard', 'High', 'Ultra high'][index],
                          gifQualityIndex == index,
                          () => setState(() => gifQualityIndex = index),
                        );
                      }),
                    ),
                    const SizedBox(height: 25),
                    const Divider(color: Colors.white12),
                    const Center(
                      child: Text(
                        'GIF export quality selected',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  ] else ...[
                    switchRow(
                      'AI Ultra HD',
                      'Sharpen video details.',
                      aiUltraHD,
                      (v) => setState(() => aiUltraHD = v),
                    ),
                    const SizedBox(height: 22),
                    sliderSection(
                      title: 'Resolution',
                      subtitle: 'High definition - ultimate viewing experience',
                      value: resolutionIndex,
                      labels: resolutions,
                      onChanged: (v) => setState(() => resolutionIndex = v),
                    ),
                    const SizedBox(height: 35),
                    sliderSection(
                      title: 'Frame rate',
                      subtitle: 'Smoother playback',
                      value: frameRateIndex,
                      labels: frameRates,
                      onChanged: (v) => setState(() => frameRateIndex = v),
                    ),
                    const SizedBox(height: 30),
                    switchRow(
                      'Optical flow',
                      'Make video playback smoother.',
                      opticalFlow,
                      (v) => setState(() => opticalFlow = v),
                    ),
                    const SizedBox(height: 25),
                    sliderSection(
                      title: 'Bitrate (Mbps)',
                      subtitle: 'Recommended for this video (12)',
                      value: bitrateIndex,
                      labels: bitrates,
                      onChanged: (v) => setState(() => bitrateIndex = v),
                    ),
                    const SizedBox(height: 25),
                    const Divider(color: Colors.white12),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        'Estimated file size depends on video length and settings',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
