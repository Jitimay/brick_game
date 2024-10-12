import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class GameMenu extends PositionComponent with TapCallbacks {
  final VoidCallback onRestart;
  final VoidCallback onLevelSelect;

  GameMenu({
    required Vector2 size,
    required Vector2 position,
    required this.onRestart,
    required this.onLevelSelect,
  }) : super(size: size, position: position);

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), const Radius.circular(8)),
      Paint()..color = Colors.black.withOpacity(0.5),
    );

    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Menu',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        (size.x - textPainter.width) / 2,
        (size.y - textPainter.height) / 2,
      ),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    _showMenuOptions();
  }

  void _showMenuOptions() {
    // In a real implementation, you'd show a proper UI dialog here.
    // For simplicity, we'll just print the options and call the callbacks directly.
    print('Menu Options:');
    print('1. Restart Game');
    print('2. Level Selection');

    // Simulate user selecting option 1 (Restart Game)
    onRestart();

    // If you want to simulate selecting option 2 (Level Selection), uncomment the line below
    // onLevelSelect();
  }
}