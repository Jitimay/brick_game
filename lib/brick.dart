import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:brick_game/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';

class Brick extends PositionComponent with HasGameRef<BrickGame>, CollisionCallbacks {
  int health;
  late final Color baseColor;

  Brick({required Vector2 size, required this.health}) : super(size: size) {
    baseColor = _getRandomColor();
  }

  late Paint paint;

  @override
  FutureOr<void> onLoad() {
    paint = Paint()..color = baseColor;
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(getRRect(), paint);
    final textPainter = TextPainter(
      text: TextSpan(text: health.toString(), style: TextStyle(color: Colors.white, fontSize: size.y * 0.5)),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(size.x / 2 - textPainter.width / 2, size.y / 2 - textPainter.height / 2));
  }
  
  RRect getRRect() => RRect.fromRectAndRadius(size.toRect(), Radius.circular(size.x * 0.1));

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    hit();
  }

  void hit() {
    health--;
    if (health <= 0) {
      destroy();
    } else {
      paint.color = baseColor.withOpacity(health / game.currentLevel);
    }
  }

  void destroy() {
    game.bricks.remove(this);
    game.world.remove(this);
    game.score += 100;
    _playDestroySound();
    _addDestroyEffect();
  }

  void _playDestroySound() {
    FlameAudio.play('audio.wav');
  }

  void _addDestroyEffect() {
    final particleComponent = ParticleSystemComponent(
      particle: Particle.generate(
        count: 20,
        lifespan: 0.5,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, 200),
          speed: Vector2(Random().nextDouble() * 200 - 100, Random().nextDouble() * -200),
          position: position.clone(),
          child: CircleParticle(
            radius: 2,
            paint: Paint()..color = baseColor.withOpacity(0.5),
          ),
        ),
      ),
    );

    game.world.add(particleComponent);
  }

  Color _getRandomColor() {
    final colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.purple, Colors.orange];
    return colors[Random().nextInt(colors.length)];
  }
}