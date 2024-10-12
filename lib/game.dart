import 'dart:async';
import 'dart:math';
import 'package:brick_game/text_button_component.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:brick_game/ball.dart';
import 'package:brick_game/bar.dart';
import 'package:brick_game/brick.dart';

class BrickGame extends FlameGame with HasCollisionDetection, TapDetector {
  static double grid = 0.1;
  static late Vector2 gridSize;

  final World world = World();
  late CameraComponent cameraComponent;
  late SpriteComponent background;
  
  List<Brick> bricks = [];
  Bar? bar;
  Ball? ball;

  int currentLevel = 1;
  int score = 0;
  bool isPaused = false;

  late TextComponent scoreText;
  late RectangleComponent controlPanel;
  late TextButtonComponent restartButton;
  late TextButtonComponent pauseButton;
  late TextButtonComponent levelButton;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load background image
    background = SpriteComponent(
      sprite: await loadSprite('batman.jpeg'),
      size: size,
    );
    add(background);

    gridSize = Vector2(size.x * grid, size.y * grid);
    add(world);
    cameraComponent = CameraComponent(world: world)
      ..viewfinder.anchor = Anchor.topLeft;
    add(cameraComponent);

    // Create control panel
    controlPanel = RectangleComponent(
      size: Vector2(size.x * 0.2, size.y),
      position: Vector2.zero(),
      paint: Paint()..color = Colors.brown.withOpacity(0.7),
    );
    add(controlPanel);

    // Create buttons
    restartButton = TextButtonComponent(
      text: 'Restart',
      textRenderer: TextPaint(style: TextStyle(color: Colors.white, fontSize: 20)),
      button: RectangleComponent(
        size: Vector2(size.x * 0.15, size.y * 0.1),
        paint: Paint()..color = Colors.blue,
      ),
      position: Vector2(size.x * 0.025, size.y * 0.2),
      onPressed: restartGame,
    );
    add(restartButton);

    pauseButton = TextButtonComponent(
      text: 'Pause',
      textRenderer: TextPaint(style: TextStyle(color: Colors.white, fontSize: 20)),
      button: RectangleComponent(
        size: Vector2(size.x * 0.15, size.y * 0.1),
        paint: Paint()..color = Colors.green,
      ),
      position: Vector2(size.x * 0.025, size.y * 0.4),
      onPressed: togglePause,
    );
    add(pauseButton);

    levelButton = TextButtonComponent(
      text: 'Level',
      textRenderer: TextPaint(style: TextStyle(color: Colors.white, fontSize: 20)),
      button: RectangleComponent(
        size: Vector2(size.x * 0.15, size.y * 0.1),
        paint: Paint()..color = Colors.orange,
      ),
      position: Vector2(size.x * 0.025, size.y * 0.6),
      onPressed: showLevelSelection,
    );
    add(levelButton);

    // Create score text
    scoreText = TextComponent(
      text: 'Score: 0',
      textRenderer: TextPaint(style: TextStyle(color: Colors.white, fontSize: 20)),
      position: Vector2(size.x * 0.025, size.y * 0.1),
    );
    add(scoreText);

    bar = Bar(gridSize: gridSize);
    ball = Ball(gridSize: gridSize, level: currentLevel);

    startLevel();
  }

  void startLevel() {
    clearLevel();
    createBricks();
    resetBallAndBar();

    if (bar != null) world.add(bar!);
    if (ball != null) world.add(ball!);
    world.addAll(bricks);
  }

  void clearLevel() {
    world.removeAll(bricks);
    bricks.clear();
    if (bar != null && world.contains(bar!)) world.remove(bar!);
    if (ball != null && world.contains(ball!)) world.remove(ball!);
  }

  void createBricks() {
    int rows = 2 + currentLevel;
    int columns = 5 + currentLevel; // Reduced by 1 to account for the control panel

    Vector2 margin = Vector2(gridSize.x * 0.2, gridSize.y * 0.1);
    double totalWidth = columns * (gridSize.x + margin.x) - margin.x;
    double firstPosX = (size.x * 0.2) + ((size.x * 0.8 - totalWidth) / 2); // Adjusted for control panel

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        final brick = Brick(
          size: gridSize,
          health: Random().nextInt(currentLevel) + 1,
        );
        brick.position = Vector2(
          firstPosX + ((gridSize.x + margin.x) * j),
          margin.y + (gridSize.y + margin.y) * i,
        );
        bricks.add(brick);
      }
    }
  }

  void resetBallAndBar() {
    if (bar != null) {
      bar!.position = Vector2(size.x / 2, size.y - gridSize.y * 2);
    }

    if (ball != null) {
      ball!.position = Vector2(size.x / 2, size.y / 2);
      ball!.resetForLevel(currentLevel);
    }
  }

  void checkLevelCompletion() {
    if (bricks.isEmpty) {
      currentLevel++;
      score += 1000 * currentLevel;
      startLevel();
    }
  }

  @override
  void update(double dt) {
    if (!isPaused) {
      super.update(dt);
      checkLevelCompletion();
      scoreText.text = 'Score: $score';
    }
  }

  void restartGame() {
    currentLevel = 1;
    score = 0;
    startLevel();
  }

  void togglePause() {
    isPaused = !isPaused;
    pauseButton.text = isPaused ? 'Resume' : 'Pause';
  }

  void showLevelSelection() {
    // Implement level selection logic here
    // For now, let's just increment the level
    currentLevel = (currentLevel % 10) + 1;
    startLevel();
  }

  @override
  Color backgroundColor() => Colors.transparent;
}