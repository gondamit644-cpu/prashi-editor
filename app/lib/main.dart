
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Export feature अगली update में आएगा'),
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
