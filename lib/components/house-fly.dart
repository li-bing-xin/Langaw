import 'package:flutter/material.dart';

import './fly.dart';
import 'package:langaw/langaw-game.dart';
import 'package:flame/sprite.dart';

class HouseFly extends Fly {
  HouseFly(LangawGame game, double x, double y) : super(game, 6) {
    flyingSprite = List();
    flyingSprite.add(Sprite('flies/house-fly-1.png'));
    flyingSprite.add(Sprite('flies/house-fly-2.png'));
    deadSprite = Sprite('flies/house-fly-dead.png');

    flyRect = Rect.fromLTWH(x, y, game.tileSize * 1, game.tileSize * 1);
    speed *= 1;
  }
}
