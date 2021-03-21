import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:langaw/langaw-game.dart';

class MusicButton {
  final LangawGame game;
  Rect rect;
  Sprite enabledSprite;
  Sprite disabledSprite;
  bool isEnabled = true;

  MusicButton(this.game) {
    rect = Rect.fromLTWH(game.tileSize * .25, game.tileSize * 0.25,
        game.tileSize, game.tileSize);
    enabledSprite = Sprite('ui/icon-music-enabled.png');
    disabledSprite = Sprite('ui/icon-music-disabled.png');
  }

  void render(Canvas c) {
    if (isEnabled)
      enabledSprite.renderRect(c, rect);
    else
      disabledSprite.renderRect(c, rect);
  }

  void onTapDown() {
    isEnabled = !isEnabled;
    print(isEnabled);
    double volume = isEnabled ? .25 : 0;
    game.homeBGM.setVolume(volume);
    game.playingBGM.setVolume(volume);
  }
}
