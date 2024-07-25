import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puzzels15/views/screens/introduce/start_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double _soundVolume = 0.5;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _soundEffectsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _soundVolume = (prefs.getDouble('soundVolume') ?? 0.5);
      _soundEffectsEnabled = (prefs.getBool('soundEffectsEnabled') ?? true);
      _isPlaying = (prefs.getBool('isPlaying') ?? false);
      _audioPlayer.setVolume(_soundVolume);

      if (_isPlaying && _soundEffectsEnabled) {
        _playSound();
      }
    });
  }

  Future<void> _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('soundVolume', _soundVolume);
    await prefs.setBool('soundEffectsEnabled', _soundEffectsEnabled);
    await prefs.setBool('isPlaying', _isPlaying);
  }

  void _playSound() async {
    if (_soundEffectsEnabled) {
      await _audioPlayer.play(AssetSource('sound/sound.mp3'),
          volume: _soundVolume);
      setState(() {
        _isPlaying = true;
      });
      _savePreferences();
    }
  }

  void _pauseSound() async {
    await _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
    _savePreferences();
  }

  void _toggleSoundEffects(bool enabled) {
    setState(() {
      _soundEffectsEnabled = enabled;
    });
    _savePreferences();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 80.0,
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    onPressed: () {
                      Get.to(
                        const MainScreen(),
                        transition: Transition.circularReveal,
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.blue,
                    ),
                  ),
                  title: const Text(
                    'Settings',
                    style: TextStyle(color: Colors.blue),
                  ),
                  centerTitle: true,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sound',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Adjust the sound volume:',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      Slider(
                        activeColor: Colors.blue,
                        value: _soundVolume,
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        label: (_soundVolume * 100).round().toString(),
                        onChanged: (value) {
                          setState(() {
                            _soundVolume = value;
                          });
                          _audioPlayer.setVolume(_soundVolume);
                          _savePreferences();
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Current Volume: ${(_soundVolume * 100).round()}%',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(390, 50),
                            backgroundColor: Colors.blue),
                        onPressed: _isPlaying ? _pauseSound : _playSound,
                        child: Text(
                          _isPlaying ? 'Pause Sound' : 'Play Sound',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SwitchListTile(
                        title: const Text(
                          'Sound Effects',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        value: _soundEffectsEnabled,
                        onChanged: (value) {
                          _toggleSoundEffects(value);
                          if (!value && _isPlaying) {
                            _pauseSound();
                          }
                        },
                        activeColor: Colors.blue,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'More Settings Coming Soon...',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
