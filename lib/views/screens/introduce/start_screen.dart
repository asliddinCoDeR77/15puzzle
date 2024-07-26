import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puzzels15/views/screens/game/game_screen.dart';
import 'package:puzzels15/views/screens/game/setting_screen.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                const Text(
                  'Welcome to the Puzzle Game!',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),
                ZoomTapAnimation(
                  child: Stack(
                    children: [
                      Transform.translate(
                        offset: const Offset(0, 4),
                        child: Container(
                          width: 200,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Container(
                        width: 200,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            'Start',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Get.to(const GameScreen(),
                        transition: Transition.circularReveal);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
