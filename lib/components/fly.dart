import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:langaw/langaw-game.dart';
import 'package:flame/sprite.dart';
import 'package:langaw/view.dart';
import './callout.dart';

class Fly {
  final LangawGame game;
  Rect flyRect;
  bool isDead = false;
  bool isOffScreen = false;
  List<Sprite> flyingSprite;
  Sprite deadSprite;
  double flyingSpriteIndex = 0;
  double speed;
  Offset targetLocation;
  Callout callout;

  Fly(this.game, double t) {
    callout = Callout(this, t);
    speed = game.tileSize * 7;
    setTargetLocation();
  }

  void render(Canvas c) {
    if (isDead) {
      deadSprite.renderRect(c, flyRect.inflate(flyRect.width / 2));
    } else {
      flyingSprite[flyingSpriteIndex.toInt()]
          .renderRect(c, flyRect.inflate(flyRect.width / 2));
      if (game.activeView == View.playing) callout.render(c);
    }
  }

  void update(double t) {
    if (isDead) {
      flyRect = flyRect.translate(0, game.tileSize * 10 * t);
      if (flyRect.top > game.screenSize.height) {
        isOffScreen = true;
      }
    } else {
      //苍蝇煽动翅膀的动画
      flyingSpriteIndex += 30 * t;
      while (flyingSpriteIndex >= 2) {
        flyingSpriteIndex -= 2;
      }

      //控制苍蝇移动
      double stepDistance = speed * t;
      Offset toTarget = targetLocation - Offset(flyRect.left, flyRect.top);
      if (stepDistance < toTarget.distance) {
        Offset stepToTarget =
            Offset.fromDirection(toTarget.direction, stepDistance);
        flyRect = flyRect.shift(stepToTarget);
      } else {
        flyRect = flyRect.shift(toTarget);
        setTargetLocation();
      }

      callout.update(t);
    }
  }

  void onTapDown() {
    if (!isDead) {
      isDead = true;
      if (game.activeView == View.playing) {
        game.score += 1;
        // if (game.score > (game.storage.getInt('highscore') ?? 0)) {
        //   game.storage.setInt('highscore', game.score);
        //   game.highscoreDisplay.updateHighscore();
        // }
        if (game.soundButton.isEnabled)
          Flame.audio.play(
              'sfx/ouch' + (game.rnd.nextInt(11) + 1).toString() + '.ogg');
        if (game.score > (game.maxScore)) {
          game.maxScore = game.score;
          game.highscoreDisplay.updateHighscore();
        }
      }
    }
  }

  void setTargetLocation() {
    double x =
        game.rnd.nextDouble() * (game.screenSize.width - game.tileSize * 1.35);
    double y = game.rnd.nextDouble() *
            (game.screenSize.height - game.tileSize * 2.85) +
        game.tileSize * 1.5;
    targetLocation = Offset(x, y);
  }
}
