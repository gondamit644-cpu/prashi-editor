
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';

const purple = Color(0xFF9B5CFF);
const bg = Color(0xFF101014);
const panel = Color(0xFF1D1D25);
const muted = Color(0xFF9999A8);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  runApp(const PrashiApp());
}

class PrashiApp extends StatelessWidget {
  const PrashiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prashi Toon Editor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.dark(primary: purple),
        useMaterial3: true,
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

  Widget toolIcon(IconData icon, String label) {
    return InkWell(
      onTap: newProject,
      child: Column(
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: panel,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: purple, size: 27),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bg,
        title: const Text(
          'Prashi Toon Editor',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF52259C), Color(0xFF24163E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CREATE YOUR STORY',
                    style: TextStyle(
                      color: Colors.white70,
                      letterSpacing: 2,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Make Amazing Videos',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: newProject,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('New Project'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 27),
            const Text(
              'Quick Tools',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                toolIcon(Icons.content_cut, 'Trim'),
                toolIcon(Icons.speed, 'Speed'),
                toolIcon(Icons.music_note, 'Music'),
                toolIcon(Icons.text_fields, 'Text'),
              ],
            ),
            const SizedBox(height: 25),
            const Text(
              'AI TOOLS',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: const [
                HomeTool(Icons.auto_awesome, 'AI Effects'),
                HomeTool(Icons.closed_caption, 'Auto Captions'),
                HomeTool(Icons.face_retouching_natural, 'Beauty'),
                HomeTool(Icons.video_library, 'Video Templates'),
              ],
            ),
            const SizedBox(height: 25),
            const Text(
              'Editing Studio',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: panel,
                borderRadius: BorderRadius.circular(17),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.movie_creation_outlined,
                    size: 38,
                    color: purple,
                  ),
                  const SizedBox(width: 13),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Start Editing',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Choose a video from your Gallery',
                          style: TextStyle(color: muted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: newProject,
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: purple,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: panel,
        indicatorColor: purple.withOpacity(0.25),
        selectedIndex: selectedTab,
        onDestinationSelected: (value) {
          setState(() => selectedTab = value);
          if (value == 1) newProject();
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.video_library_outlined),
            label: 'Projects',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            label: 'AI Tools',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Me',
          ),
        ],
      ),
    );
  }
}

class HomeTool extends StatelessWidget {
  final IconData icon;
  final String title;

  const HomeTool(this.icon, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: purple, size: 21),
          const SizedBox(width: 8),
          Flexible(
            child: Text(title, style: const TextStyle(fontSize: 12)),
          ),
        ],
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
  int selectedTool = 0;
  String? errorMessage;

  String selectedRatioName = 'Original';
  double? selectedRatio;

  final List<Map<String, dynamic>> ratios = [
    {'name': 'Original', 'ratio': null},
    {'name': '9:16', 'ratio': 9 / 16},
    {'name': '16:9', 'ratio': 16 / 9},
    {'name': '1:1', 'ratio': 1.0},
    {'name': '4:3', 'ratio': 4 / 3},
    {'name': '5.8"', 'ratio': 5.8},
    {'name': '128:27', 'ratio': 128 / 27},
    {'name': '2:1', 'ratio': 2.0},
    {'name': '2.35:1', 'ratio': 2.35},
    {'name': '1.85:1', 'ratio': 1.85},
  ];

  final tools = const [
    ['Edit', Icons.tune],
    ['Audio', Icons.music_note],
    ['Text', Icons.text_fields],
    ['Effects', Icons.auto_awesome],
    ['Filters', Icons.filter],
    ['Overlay', Icons.layers],
    ['Captions', Icons.closed_caption],
    ['Export', Icons.download],
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
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void showRatioOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: panel,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Video Ratio',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: ratios.map((item) {
                    final name = item['name'] as String;
                    final isSelected = selectedRatioName == name;

                    return ChoiceChip(
                      label: Text(name),
                      selected: isSelected,
                      selectedColor: purple,
                      backgroundColor: bg,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                      ),
                      onSelected: (selected) {
                        if (!selected) return;

                        setState(() {
                          selectedRatioName = name;
                          selectedRatio = item['ratio'] as double?;
                        });

                        Navigator.pop(sheetContext);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
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

    if (name == 'Edit') {
      showModalBottomSheet(
        context: context,
        backgroundColor: panel,
        builder: (_) => const ToolInfo(
          title: 'Edit Tools',
          items: ['Trim', 'Split', 'Crop', 'Rotate', 'Speed', 'Reverse'],
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        backgroundColor: panel,
        builder: (_) => ToolInfo(
          title: name,
          items: const [
            'Choose a tool',
            'More editing features will be added in future updates',
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bg,
        title: const Text('Editing Studio'),
        actions: [
          TextButton.icon(
            onPressed: showRatioOptions,
            icon: const Icon(Icons.aspect_ratio, color: purple),
            label: const Text(
              'Ratio',
              style: TextStyle(color: purple),
            ),
          ),
          TextButton(
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
            child: const Text(
              'Export',
              style: TextStyle(color: purple),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: loading
                  ? const CircularProgressIndicator()
                  : errorMessage != null
                      ? Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            errorMessage!,
                            textAlign: TextAlign.center,
                          ),
                        )
                      : selectedRatio == null
                          ? Video(
                              controller: videoController,
                              fit: BoxFit.contain,
                            )
                          : AspectRatio(
                              aspectRatio: selectedRatio!,
                              child: Video(
                                controller: videoController,
                                fit: BoxFit.contain,
                              ),
                            ),
            ),
          ),
          if (!loading && errorMessage == null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                'Ratio: $selectedRatioName',
                style: const TextStyle(
                  color: purple,
                  fontSize: 12,
                ),
              ),
            ),
            StreamBuilder<Duration>(
              stream: player.stream.position,
              initialData: Duration.zero,
              builder: (context, positionSnapshot) {
                final position = positionSnapshot.data ?? Duration.zero;

                return StreamBuilder<Duration>(
                  stream: player.stream.duration,
                  initialData: Duration.zero,
                  builder: (context, durationSnapshot) {
                    final duration =
                        durationSnapshot.data ?? Duration.zero;

                    final maxValue =
                        duration.inMilliseconds.toDouble();

                    final currentValue = position.inMilliseconds
                        .toDouble()
                        .clamp(0.0, maxValue > 0 ? maxValue : 1.0)
                        .toDouble();

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Text(
                            timeText(position),
                            style: const TextStyle(fontSize: 11),
                          ),
                          Expanded(
                            child: Slider(
                              value: currentValue,
                              max: maxValue > 0 ? maxValue : 1.0,
                              activeColor: purple,
                              onChanged: duration.inMilliseconds > 0
                                  ? (value) {
                                      player.seek(
                                        Duration(
                                          milliseconds: value.round(),
                                        ),
                                      );
                                    }
                                  : null,
                            ),
                          ),
                          Text(
                            timeText(duration),
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            StreamBuilder<bool>(
              stream: player.stream.playing,
              initialData: false,
              builder: (context, snapshot) {
                final isPlaying = snapshot.data ?? false;

                return IconButton(
                  iconSize: 45,
                  color: purple,
                  onPressed: () {
                    if (isPlaying) {
                      player.pause();
                    } else {
                      player.play();
                    }
                  },
                  icon: Icon(
                    isPlaying ? Icons.pause_circle : Icons.play_circle,
                  ),
                );
              },
            ),
          ],
          Container(
            height: 85,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: panel,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.movie, color: purple),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Video Timeline',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Icon(Icons.graphic_eq, color: muted),
              ],
            ),
          ),
          Container(
            height: 105,
            color: panel,
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
                          color: active ? purple : Colors.white70,
                        ),
                        const SizedBox(height: 7),
                        Text(
                          item[0] as String,
                          style: TextStyle(
                            fontSize: 11,
                            color: active ? purple : Colors.white70,
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
    );
  }
}

class ToolInfo extends StatelessWidget {
  final String title;
  final List<String> items;

  const ToolInfo({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 9),
                child: Text(
                  item,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
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
  bool showSettings = true;
  bool exporting = false;

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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
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
                color: selected
                    ? const Color(0xFF25D9E8)
                    : Colors.transparent,
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
            activeThumbColor: const Color(0xFF25D9E8),
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
          activeColor: const Color(0xFF25D9E8),
          inactiveColor: Colors.white24,
          onChanged: (v) => onChanged(v.round()),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: labels
              .map(
                (label) => Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  String quotePath(String path) {
    return '"${path.replaceAll('"', '\\"')}"';
  }

  Future<void> startExport() async {
    if (exporting) return;

    setState(() => exporting = true);

    try {
      final directory = await getTemporaryDirectory();
      final stamp = DateTime.now().millisecondsSinceEpoch;

      final String outputPath;

      if (isGif) {
        outputPath = '${directory.path}/prashi_$stamp.gif';

        final gifSizes = [240, 320, 640];
        final size = gifSizes[gifQualityIndex];

        final command =
            '-y -i ${quotePath(widget.videoPath)} '
            '-vf "fps=15,scale=$size:-1:flags=lanczos,'
            'split[s0][s1];[s0]palettegen[p];'
            '[s1][p]paletteuse" '
            '-loop 0 ${quotePath(outputPath)}';

        final session = await FFmpegKit.execute(command);
        final returnCode = await session.getReturnCode();

        if (!ReturnCode.isSuccess(returnCode)) {
          final logs = await session.getOutput();
          throw Exception(logs ?? 'GIF बनाने में समस्या आई।');
        }
      } else {
        outputPath = '${directory.path}/prashi_$stamp.mp4';

        final heights = [480, 720, 1080, 1440, 2160];
        final height = heights[resolutionIndex];
        final fps = frameRates[frameRateIndex];
        final bitrate = bitrates[bitrateIndex];

        final filters = <String>[];

        filters.add(
          "scale='if(gte(iw,ih),$height,-2)':"
          "'if(gte(iw,ih),-2,$height)':"
          'force_divisible_by=2',
        );

        filters.add('fps=$fps');

        if (aiUltraHD) {
          filters.add('unsharp=5:5:0.8:3:3:0.4');
        }

        if (opticalFlow) {
          filters.add('minterpolate=fps=$fps');
        }

        final command =
            '-y -i ${quotePath(widget.videoPath)} '
            '-vf "${filters.join(',')}" '
            '-c:v libx264 -preset ultrafast '
            '-b:v ${bitrate}M '
            '-maxrate ${bitrate}M '
            '-bufsize ${bitrate * 2}M '
            '-pix_fmt yuv420p '
            '-c:a aac -b:a 192k '
            '-movflags +faststart '
            '${quotePath(outputPath)}';

        final session = await FFmpegKit.execute(command);
        final returnCode = await session.getReturnCode();

        if (!ReturnCode.isSuccess(returnCode)) {
          final logs = await session.getOutput();
          throw Exception(logs ?? 'Video export में समस्या आई।');
        }
      }

      final result = await SaverGallery.saveFile(
        filePath: outputPath,
        fileName: isGif ? 'Prashi_$stamp.gif' : 'Prashi_$stamp.mp4',
        skipIfExists: false,
        albumPath: 'Prashi Toon Editor',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gallery में सेव हो गया: ${result.savedUri ?? "Success"}',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export असफल: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => exporting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    onTap: () {
                      setState(() => showSettings = !showSettings);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF303030),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Text('AI UHD'),
                          const SizedBox(width: 4),
                          Icon(
                            showSettings
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: exporting ? null : startExport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF20CDE0),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: exporting
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : const Text('Export'),
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
                          () {
                            setState(() => gifQualityIndex = index);
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 25),
                    const Divider(color: Colors.white12),
                    const SizedBox(height: 15),
                    const Center(
                      child: Text(
                        'GIF export quality selected',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  ] else if (showSettings) ...[
                    switchRow(
                      'AI Ultra HD',
                      'Sharpen video details.',
                      aiUltraHD,
                      (value) => setState(() => aiUltraHD = value),
                    ),
                    const SizedBox(height: 22),
                    sliderSection(
                      title: 'Resolution',
                      subtitle:
                          'High definition - the ultimate viewing experience',
                      value: resolutionIndex,
                      labels: resolutions,
                      onChanged: (value) {
                        setState(() => resolutionIndex = value);
                      },
                    ),
                    const SizedBox(height: 35),
                    sliderSection(
                      title: 'Frame rate',
                      subtitle: 'Smoother playback',
                      value: frameRateIndex,
                      labels: frameRates,
                      onChanged: (value) {
                        setState(() => frameRateIndex = value);
                      },
                    ),
                    const SizedBox(height: 30),
                    switchRow(
                      'Optical flow',
                      'Make video playback smoother.',
                      opticalFlow,
                      (value) => setState(() => opticalFlow = value),
                    ),
                    const SizedBox(height: 25),
                    sliderSection(
                      title: 'Bitrate (Mbps)',
                      subtitle: 'Recommended for this video (12)',
                      value: bitrateIndex,
                      labels: bitrates,
                      onChanged: (value) {
                        setState(() => bitrateIndex = value);
                      },
                    ),
                    const SizedBox(height: 25),
                    const Divider(color: Colors.white12),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        'Estimated file size will appear here',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      height: 105,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF261044),
                            Color(0xFF090909),
                          ],
                        ),
                      ),
                      child: const Row(
                        children: [
                          SizedBox(width: 18),
                          Icon(
                            Icons.settings_suggest,
                            color: Color(0xFFB66CFF),
                            size: 35,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'More export settings',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white70,
                            size: 17,
                          ),
                          SizedBox(width: 15),
                        ],
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
