// main.dart

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mobile_app/api/spotify_api.dart';
import 'package:mobile_app/models/playlist.dart';
import 'package:mobile_app/models/track.dart';
import 'package:mobile_app/providers/music_provider.dart';
import 'package:provider/provider.dart';
import 'search.dart';
import 'authorization.dart';
import 'services/spotify_player.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const clientId = 'cf72b6dcb97f43bfba40c07c968a429e';
  const clientSecret = '1994a11fef4840c9b63161da58aacae0';

  final api = SpotifyApi(clientId, clientSecret);

  if (!kIsWeb) {
    await connectToSpotify();
    await SpotifyPlayer.initialize();
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => MusicProvider(api),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite(WordPair pair) {
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const GeneratorPage();
      case 1:
        page = const FavoritesPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                    print('selected: $value');
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Column(
      children: [
        const SearchBox(),
        BigCard(pair: pair),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                appState.toggleFavorite(pair);
              },
              icon: Icon(icon),
              label: const Text('Like'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                appState.getNext();
              },
              child: const Text('Next'),
            ),
          ],
        ),
        // display tracks if available - Integrated playlist controls
        Expanded(
          child: Consumer<MusicProvider>(
            builder: (context, musicProvider, child) {
              if (musicProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (musicProvider.tracks.isNotEmpty) {
                return Column(
                  children: [
                    // Track List with Add/Remove Buttons
                    Expanded(
                      child: ListView.builder(
                        itemCount: musicProvider.tracks.length,
                        itemBuilder: (context, index) {
                          final track = musicProvider.tracks[index];
                          return ListTile(
                            leading: Image.network(
                              track.imgURL,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.music_note),
                            ),
                            title: Text(track.name),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.green,
                                  ),
                                  onPressed: () =>
                                      musicProvider.addToPlaylist(track),
                                  tooltip: 'Add to Playlist',
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove,
                                    color: Colors.red,
                                  ),
                                  onPressed: () =>
                                      musicProvider.removeFromPlaylist(track),
                                  tooltip: 'Remove from Playlist',
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    // playlist Controls
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: musicProvider.printCurrentPlaylist,
                            icon: const Icon(Icons.list),
                            label: const Text('View Playlist'),
                          ),
                          ElevatedButton.icon(
                            onPressed: musicProvider.clearPlaylist,
                            icon: const Icon(Icons.clear),
                            label: const Text('Clear Playlist'),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var musicProvider = context.watch<MusicProvider>();
    final savedTracks = musicProvider.currentPlaylist;

    if (savedTracks.isEmpty()) {
      return const Center(child: Text('No saved tracks yet.'));
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have ${musicProvider.currentPlaylist.length} saved songs:'),
        ),
        // ignore: unused_local_variable
        for (var track in savedTracks.trackList)
          ListTile(
            leading: const Icon(Icons.favorite),
            title: Text(track.name),
          ),
      ],
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({super.key, required this.pair});

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}
