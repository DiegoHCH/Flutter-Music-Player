import 'package:flutter/material.dart';
import 'package:music_player/res/theme/theme.dart';
import 'package:music_player/viewmodels/audioplayer_viewmodel.dart';
import 'package:music_player/views/music_player_view.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AudioPlayerViewModel())
      ],
      child: MaterialApp(
        title: 'Music Player',
        theme: miTema,
        debugShowCheckedModeBanner: false,
        home: const MusicPlayerView()
      ),
    );
  }
}