import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:langaw/components/fly.dart';
import 'package:langaw/langaw-game.dart';

class AgileFly extends Fly {
  AgileFly(LangawGame game, double x, double y) : super(game, 4) {
    flyingSprite = List();
    flyingSprite.add(Sprite('flies/agile-fly-1.png'));
    flyingSprite.add(Sprite('flies/agile-fly-2.png'));
    deadSprite = Sprite('flies/agile-fly-dead.png');

    flyRect = Rect.fromLTWH(x, y, game.tileSize * 1, game.tileSize * 1);
    speed *= 2.5;
  }
}
