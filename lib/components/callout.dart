import 'dart:ffi';
import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flame/sprite.dart';
import 'package:langaw/components/fly.dart';
import 'package:langaw/view.dart';

class Callout {
  final Fly fly;
  Rect rect;
  Sprite sprite;
  double value;

  TextPainter tp;
  TextStyle textStyle;
  Offset textOffset;

  Callout(this.fly, double t) {
    sprite = Sprite('ui/callout.png');
    value = t ?? 5;
    tp = TextPainter(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    textStyle = TextStyle(color: Color(0xff000000), fontSize: 15);
  }

  void render(Canvas c) {
    if (rect != null) {
      sprite.renderRect(c, rect);
      tp.paint(c, textOffset);
    }
  }

  void update(double t) {
    if (fly.game.activeView == View.playing) {
      value = value - 1 * t;
      if (value <= 0) {
        fly.game.activeView = View.lost;
        if (fly.game.soundButton.isEnabled)
          Flame.audio.play(
              'sfx/haha' + (fly.game.rnd.nextInt(5) + 1).toString() + '.ogg');
        fly.game.playHomeBGM();
      }

      rect = Rect.fromLTWH(
          fly.flyRect.left - fly.game.tileSize * 0.25,
          fly.flyRect.top - fly.game.tileSize * 0.5,
          fly.game.tileSize * 0.75,
          fly.game.tileSize * 0.75);

      tp.text =
          TextSpan(text: (value * 10).toInt().toString(), style: textStyle);

      tp.layout();
      textOffset = Offset(rect.center.dx - tp.width / 2,
          rect.top + rect.height * 0.4 - tp.height / 2);
    }
  }
}
