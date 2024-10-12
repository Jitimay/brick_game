import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

class Bar extends PositionComponent with DragCallbacks, HasGameRef {
  final Vector2 gridSize;

  Bar({required this.gridSize}) : super(size: Vector2(gridSize.x * 2, gridSize.y / 2));

  Paint paint = Paint()..color = Colors.green;

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(getRRect(), paint);
  }

  RRect getRRect() {
    return RRect.fromRectAndRadius(size.toRect(), Radius.circular(gridSize.x * 0.1));
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    x += event.localDelta.x;

    if (x < 0) x = 0;
    if (x + width > gameRef.size.x) x = gameRef.size.x - width;
  }
}
