import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class TextButtonComponent extends PositionComponent with TapCallbacks {
  final String text;
  final TextPaint textRenderer;
  final RectangleComponent button;
  final VoidCallback onPressed;

  late TextComponent _textComponent;

  TextButtonComponent({
    required this.text,
    required this.textRenderer,
    required this.button,
    required this.onPressed,
    required Vector2 position,
  }) : super(position: position) {
    size = button.size;
    _textComponent = TextComponent(
      text: text,
      textRenderer: textRenderer,
    );
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(button);
    add(_textComponent);
    _textComponent.position = size / 2 - _textComponent.size / 2;
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onPressed();
  }

  set text(String newText) {
    _textComponent.text = newText;
  }
}