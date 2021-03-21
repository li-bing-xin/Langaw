import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:langaw/components/fly.dart';
import 'package:langaw/langaw-game.dart';

class DroolerFly extends Fly {
  DroolerFly(LangawGame game, double x, double y) : super(game, 5) {
    flyingSprite = List();
    flyingSprite.add(Sprite('flies/drooler-fly-1.png'));
    flyingSprite.add(Sprite('flies/drooler-fly-2.png'));
    deadSprite = Sprite('flies/drooler-fly-dead.png');

    flyRect = Rect.fromLTWH(x, y, game.tileSize * 1, game.tileSize * 1);
    speed *= 2;
  }
}
