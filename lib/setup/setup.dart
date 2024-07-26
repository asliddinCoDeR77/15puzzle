import 'package:audioplayers/audioplayers.dart';
import 'package:get_it/get_it.dart';
import 'package:puzzels15/services/puzzle_services.dart';

final GetIt dependency = GetIt.instance;

void dependencysetup() {
  dependency.registerSingleton(() => AudioPlayer());
  dependency.registerSingleton(() => PuzzleService());
}
