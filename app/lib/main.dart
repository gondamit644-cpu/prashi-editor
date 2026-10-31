import 'package:flutter/material.dart';

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
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: purple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int tab = 0;

  final pages = const [
    HomePage(),
    AiPage(),
    EffectsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: pages[tab]),
      bottomNavigationBar: NavigationBar(
        backgroundColor: panel,
        indicatorColor: purple.withOpacity(.25),
        selectedIndex: tab,
        onDestinationSelected: (value) {
          setState(() => tab = value);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: purple),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            label: 'AI Tools',
          ),
          NavigationDestination(
            icon: Icon(Icons.movie_filter_outlined),
            label: 'Effects',
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Row(
          children: [
            const Icon(Icons.play_circle_fill, color: purple, size: 38),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Prashi Toon Editor',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF5426A5), Color(0xFF24143F)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CREATE AMAZING VIDEOS',
                style: TextStyle(
                  color: Colors.white70,
                  letterSpacing: 1.5,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your creativity,\\nyour video studio.',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                ),
                onPressed: () => showMessage(context, 'Video picker अगली अपडेट में आएगा।'),
                icon: const Icon(Icons.add),
                label: const Text('New Project'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        const SectionTitle('Quick Tools'),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.05,
          children: const [
            ToolTile(Icons.closed_caption, 'Auto Captions'),
            ToolTile(Icons.person_remove_alt_1, 'Remove BG'),
            ToolTile(Icons.face_retouching_natural, 'Retouch'),
            ToolTile(Icons.speed, 'Speed'),
            ToolTile(Icons.music_note, 'Audio'),
            ToolTile(Icons.auto_awesome, 'AI Video'),
          ],
        ),
        const SizedBox(height: 26),
        const SectionTitle('Trending Effects'),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(child: EffectTile(Icons.flash_on, 'Flash Glow')),
            SizedBox(width: 12),
            Expanded(child: EffectTile(Icons.blur_on, 'Dream Blur')),
            SizedBox(width: 12),
            Expanded(child: EffectTile(Icons.color_lens, 'Neon')),
          ],
        ),
        const SizedBox(height: 26),
        const SectionTitle('Popular Filters'),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(child: FilterTile('Cinematic', Color(0xFF735A45))),
            SizedBox(width: 10),
            Expanded(child: FilterTile('Vintage', Color(0xFF8B684C))),
            SizedBox(width: 10),
            Expanded(child: FilterTile('Cool', Color(0xFF416C86))),
          ],
        ),
        const SizedBox(height: 24),
        const Center(
          child: Text(
            'Made with ❤️ by Prashi Toon',
            style: TextStyle(color: Colors.white38),
          ),
        ),
      ],
    );
  }
}

class AiPage extends StatelessWidget {
  const AiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: 'AI Studio',
      subtitle: 'Create videos with smart AI tools',
      items: const [
        ['Auto AI Captions', Icons.closed_caption],
        ['AI Background Remover', Icons.person_remove],
        ['AI Video Generator', Icons.movie_creation],
        ['AI Retouch', Icons.face_retouching_natural],
        ['AI Voice Tools', Icons.record_voice_over],
      ],
    );
  }
}

class EffectsPage extends StatelessWidget {
  const EffectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: 'Effects & Filters',
      subtitle: 'Give your videos a new look',
      items: const [
        ['Trending Effects', Icons.flash_on],
        ['Glitch Effects', Icons.broken_image],
        ['Blur Effects', Icons.blur_on],
        ['Cinematic Filters', Icons.camera],
        ['Vintage Filters', Icons.filter_vintage],
        ['Color Effects', Icons.color_lens],
      ],
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            radius: 38,
            backgroundColor: purple,
            child: Icon(Icons.person, size: 42, color: Colors.white),
          ),
          SizedBox(height: 18),
          Text(
            'Prashi Toon Editor',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Your creative video studio'),
          SizedBox(height: 30),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About App'),
          ),
        ],
      ),
    );
  }
}

class SimplePage extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<List<dynamic>> items;

  const SimplePage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(title, style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(subtitle, style: const TextStyle(color: Colors.white60)),
        const SizedBox(height: 24),
        ...items.map(
          (item) => Card(
            color: panel,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: purple.withOpacity(.2),
                child: Icon(item[1] as IconData, color: purple),
              ),
              title: Text(item[0] as String),
              trailing: const Icon(Icons.arrow_forward_ios, size: 15),
              onTap: () => showMessage(context, 'यह फीचर अगली अपडेट में आएगा।'),
            ),
          ),
        ),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
    );
  }
}

class ToolTile extends StatelessWidget {
  final IconData icon;
  final String title;
  const ToolTile(this.icon, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => showMessage(context, '$title अगली अपडेट में आएगा।'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: purple, size: 29),
            const SizedBox(height: 9),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class EffectTile extends StatelessWidget {
  final IconData icon;
  final String title;
  const EffectTile(this.icon, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: purple, size: 30),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}

class FilterTile extends StatelessWidget {
  final String title;
  final Color color;
  const FilterTile(this.title, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
