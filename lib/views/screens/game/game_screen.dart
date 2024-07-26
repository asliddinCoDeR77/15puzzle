import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:puzzels15/services/puzzle_services.dart';
import 'package:puzzels15/setup/setup.dart';
import 'package:puzzels15/views/screens/game/setting_screen.dart';
import 'package:puzzels15/views/screens/introduce/start_screen.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final PuzzleService _puzzleService = dependency<PuzzleService>();
  final AudioPlayer _audioPlayer = dependency<AudioPlayer>();

  @override
  void initState() {
    super.initState();
    _puzzleService.shufflePuzzle();
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congratulations!'),
          content: const Text('You have solved the puzzle!'),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              onPressed: () {
                Navigator.of(context).pop();
                _puzzleService.shufflePuzzle();
                setState(() {});
              },
              child: const Text(
                'Play Again',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _triggerAutoWin() {
    setState(() {
      _puzzleService.setSolvedState();
    });
    _audioPlayer.play(AssetSource('sound/win.mp3'));
    _showWinDialog();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.to(const MainScreen(), transition: Transition.cupertino);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.blue,
          ),
        ),
        actions: [
          ZoomTapAnimation(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/setting.png'),
            ),
            onTap: () {
              Get.to(const SettingsPage(), transition: Transition.fadeIn);
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 310,
                  height: 390,
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GridView.builder(
                    itemCount: 16,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemBuilder: (context, index) {
                      final piece = _puzzleService.puzzlePieces[index];
                      return GestureDetector(
                        onTap: piece == 0
                            ? null
                            : () {
                                setState(() {
                                  _puzzleService.movePiece(index);
                                  if (_puzzleService.isSolved()) {
                                    _audioPlayer
                                        .play(AssetSource('sound/win.mp3'));
                                    _showWinDialog();
                                  }
                                });
                              },
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                piece == 0 ? Colors.transparent : Colors.orange,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Center(
                            child: Text(
                              piece == 0 ? '' : piece.toString(),
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: const Size(230, 50)),
                  onPressed: () {
                    _puzzleService.shufflePuzzle();
                    setState(() {});
                  },
                  child: const Text(
                    'Restart',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(230, 50)),
                  onPressed: _triggerAutoWin,
                  child: const Text(
                    'Auto-Win',
                    style: TextStyle(color: Colors.white),
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
