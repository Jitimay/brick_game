import 'package:brick_game/game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(
      MaterialApp(
        home: Scaffold(
          body: SafeArea(
            child: OrientationBuilder(
              builder: (context, orientation) {
                if (orientation == Orientation.landscape) {
                  return const GameWidget<BrickGame>.controlled(
                    gameFactory: BrickGame.new,
                  );
                } else {
                  return const Center(
                    child: Text(
                      'Please rotate your device to landscape mode to play the game.',
                      textAlign: TextAlign.center,
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  });
}