import 'dart:async';
import 'dart:ui';
import 'package:brick_game/bar.dart';
import 'package:brick_game/brick.dart';
import 'package:brick_game/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Ball extends PositionComponent with CollisionCallbacks, HasGameRef<BrickGame> {
  final Vector2 gridSize;
  final int level;
  late final double radius;
  late Vector2 velocity;

  Ball({required this.gridSize, required this.level}) : super(anchor: Anchor.center) {
    radius = gridSize.x * 0.1;
    size = Vector2.all(radius * 2);
    double speed = 150 + (level * 10);
    velocity = Vector2(speed, -speed);
  }

  Paint paint = Paint()..color = Colors.blue;

  @override
  FutureOr<void> onLoad() {
    add(CircleHitbox());
    return super.onLoad();
  }

  void resetForLevel(int level) {
    double speed = 150 + (level * 10);
    velocity = Vector2(speed, -speed);
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;

    if (x + radius > game.size.x || x - radius < 0) {
      velocity.x = -velocity.x;
    } else if (y - radius < 0) {
      velocity.y = -velocity.y;
    } else if (y + radius > game.size.y) {
      game.startLevel();
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(Offset(radius, radius), radius, paint);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Bar || other is Brick) {
      double otherMid = (other.x + (other.x + other.width)) / 2;
      double collisionOffset = x - otherMid;
      velocity.x += collisionOffset;
      velocity.y = -velocity.y;
    }
  }
}
