import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({super.key});

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  final audioPlayer = AudioPlayer();

  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    setAudio();

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  Future<void> setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    await audioPlayer.setSourceAsset('Audio/Beyonce - All Night Audio.mp3');
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = duration.inSeconds > 0
        ? position.inSeconds / duration.inSeconds
        : 0.0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.white70),
                    ),
                    const Text(
                      "Music Player",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_border,
                          color: Colors.white70),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),

                        // Cover Art
                        Container(
                          height: 280,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.4),
                                blurRadius: 40,
                                offset: const Offset(0, 20),
                              ),
                            ],
                            image: const DecorationImage(
                              image: AssetImage(
                                  'assets/appimages/background.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.4),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Judul & Artis
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'All Night',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Beyoncé',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white54,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.purple.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.playlist_add,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Progress Bar
                        Column(
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Colors.purple,
                                inactiveTrackColor:
                                    Colors.white.withOpacity(0.2),
                                thumbColor: Colors.white,
                                thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 8),
                                overlayColor:
                                    Colors.purple.withOpacity(0.2),
                                trackHeight: 4,
                              ),
                              child: Slider(
                                min: 0,
                                max: duration.inSeconds.toDouble() == 0
                                    ? 1
                                    : duration.inSeconds.toDouble(),
                                value: position.inSeconds
                                    .toDouble()
                                    .clamp(
                                      0,
                                      duration.inSeconds.toDouble() == 0
                                          ? 1
                                          : duration.inSeconds.toDouble(),
                                    ),
                                onChanged: (value) async {
                                  final newPosition =
                                      Duration(seconds: value.toInt());
                                  await audioPlayer.seek(newPosition);
                                  await audioPlayer.resume();
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    formatTime(position),
                                    style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 13),
                                  ),
                                  Text(
                                    formatTime(duration - position),
                                    style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Kontrol
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                          children: [
                            // Shuffle
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.shuffle,
                                  color: Colors.white54, size: 28),
                            ),

                            // Previous
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.skip_previous_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),

                            // Play/Pause
                            GestureDetector(
                              onTap: () async {
                                if (isPlaying) {
                                  await audioPlayer.pause();
                                } else {
                                  await audioPlayer.resume();
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colors.purple,
                                      Colors.deepPurple,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.purple.withOpacity(0.5),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  isPlaying
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),

                            // Next
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.skip_next_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),

                            // Repeat
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.repeat,
                                  color: Colors.purple, size: 28),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Volume
                        Row(
                          children: [
                            const Icon(Icons.volume_down,
                                color: Colors.white54, size: 20),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor:
                                      Colors.white.withOpacity(0.5),
                                  inactiveTrackColor:
                                      Colors.white.withOpacity(0.1),
                                  thumbColor: Colors.white,
                                  thumbShape:
                                      const RoundSliderThumbShape(
                                          enabledThumbRadius: 6),
                                  trackHeight: 2,
                                ),
                                child: Slider(
                                  value: 0.7,
                                  onChanged: (value) {},
                                ),
                              ),
                            ),
                            const Icon(Icons.volume_up,
                                color: Colors.white54, size: 20),
                          ],
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}