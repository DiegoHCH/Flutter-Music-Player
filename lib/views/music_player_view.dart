import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/utils/utils.dart';
import 'package:music_player/viewmodels/audioplayer_viewmodel.dart';
import 'package:music_player/views/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class MusicPlayerView extends StatelessWidget {
  const MusicPlayerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        const _Background(),
        Column(
          children: const [
            CustomAppBar(),
            _DiscImageAndDuration(),
            _PlayTitle(),
            Expanded(child: _Lirycs())
          ],
        ),
      ],
    ));
  }
}

class _Background extends StatelessWidget {
  const _Background({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: screenSize.height * 0.8,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60)),
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.center,
              colors: [
                Color(0xff33333E),
                Color(0xff201E28),
              ])),
    );
  }
}

class _Lirycs extends StatelessWidget {
  const _Lirycs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lirycs = getLyrics();
    return ListWheelScrollView(
        itemExtent: 42,
        diameterRatio: 1.5,
        physics: const BouncingScrollPhysics(),
        children: lirycs
            .map((line) => Text(
                  line,
                  style: TextStyle(
                      fontSize: 20, color: Colors.white.withOpacity(0.6)),
                ))
            .toList());
  }
}

class _PlayTitle extends StatefulWidget {
  const _PlayTitle({
    Key? key,
  }) : super(key: key);

  @override
  State<_PlayTitle> createState() => _PlayTitleState();
}

class _PlayTitleState extends State<_PlayTitle>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  bool firstTime = true;
  late AnimationController animationController;
  final assetAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void open() {
    final audioPlayerViewModel =
        Provider.of<AudioPlayerViewModel>(context, listen: false);

    assetAudioPlayer.open(Audio('assets/audio/Breaking-Benjamin-Far-Away.mp3'),
        autoStart: true, showNotification: true);

    assetAudioPlayer.currentPosition.listen((duration) {
      audioPlayerViewModel.current = duration;
    });

    assetAudioPlayer.current.listen((playingAudio) {
      audioPlayerViewModel.songDuration =
          playingAudio?.audio.duration ?? const Duration(seconds: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      margin: const EdgeInsets.only(top: 45),
      child: Row(
        children: [
          Column(
            children: [
              Text('Far Away',
                  style: TextStyle(
                      fontSize: 30, color: Colors.white.withOpacity(0.8))),
              Text('-Breaking Benjamin-',
                  style: TextStyle(
                      fontSize: 15, color: Colors.white.withOpacity(0.5))),
            ],
          ),
          const Spacer(),
          FloatingActionButton(
            elevation: 0,
            highlightElevation: 0,
            onPressed: () {
              final audioPlayerViewModel =
                  Provider.of<AudioPlayerViewModel>(context, listen: false);
              if (isPlaying) {
                animationController.reverse();
                isPlaying = false;
                audioPlayerViewModel.controller.stop();
              } else {
                animationController.forward();
                isPlaying = true;
                audioPlayerViewModel.controller.repeat();
              }

              if (firstTime) {
                open();
                firstTime = false;
              } else {
                assetAudioPlayer.playOrPause();
              }
            },
            backgroundColor: const Color(0xffF8CB51),
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: animationController,
            ),
          )
        ],
      ),
    );
  }
}

class _DiscImageAndDuration extends StatelessWidget {
  const _DiscImageAndDuration({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      margin: const EdgeInsets.only(top: 70),
      child: Row(
        children: const [
          _DiscImage(),
          SizedBox(width: 50),
          _ProgressBar(),
          SizedBox(width: 20)
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(color: Colors.white.withOpacity(0.4));
    final audioPlayerViewModel = Provider.of<AudioPlayerViewModel>(context);
    final porcentaje = audioPlayerViewModel.porcentaje;
    return Column(
      children: [
        Text(
          audioPlayerViewModel.songTotalDuration,
          style: style,
        ),
        const SizedBox(
          height: 10,
        ),
        Stack(
          children: [
            Container(
              width: 3,
              height: 230,
              color: Colors.white.withOpacity(0.1),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: 3,
                height: 230 * porcentaje ,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          audioPlayerViewModel.currentSecond,
          style: style,
        ),
      ],
    );
  }
}

class _DiscImage extends StatelessWidget {
  const _DiscImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioPlayerViewModel = Provider.of<AudioPlayerViewModel>(context);
    return Container(
      width: 250,
      height: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200),
          gradient: const LinearGradient(begin: Alignment.topLeft, colors: [
            Color(0xff484750),
            Color(0xff1E1C24),
          ])),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(200),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SpinPerfect(
                  duration: const Duration(seconds: 10),
                  infinite: true,
                  manualTrigger: true,
                  animate: false,
                  controller: (animationController) =>
                      audioPlayerViewModel.controller = animationController,
                  child:
                      const Image(image: AssetImage('assets/imgs/aurora.jpg'))),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(100)),
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    color: const Color(0xff1C1C25),
                    borderRadius: BorderRadius.circular(100)),
              ),
            ],
          )),
    );
  }
}
