import 'dart:ui';
import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:langaw/components/agile-fly.dart';
import 'package:langaw/components/credits-button.dart';
import 'package:langaw/components/drooler-fly.dart';
import 'package:langaw/components/fly.dart';
import 'package:flutter/gestures.dart';
import 'package:langaw/components/help-button.dart';
import 'package:langaw/components/highscore-display.dart';
import 'package:langaw/components/house-fly.dart';
import 'package:langaw/components/hungry-fly.dart';
import 'package:langaw/components/macho-fly.dart';
import 'package:langaw/components/score-display.dart';
import 'package:langaw/components/sound-button.dart';
import 'package:langaw/views/credits-view.dart';
import 'package:langaw/views/help-view.dart';
import 'package:langaw/views/lost-view.dart';
import 'components/backyard.dart';
import './view.dart';
import './views/home-view.dart';
import 'components/music-button.dart';
import 'components/start-button.dart';
import 'controllers/spawner.dart';
import 'package:audioplayers/audioplayers.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class LangawGame extends Game {
  // final SharedPreferences storage;
  Size screenSize; //记录屏幕的尺寸
  double tileSize; //定义了飞蝇的尺寸
  List<Fly> flies; //小飞蝇list
  Random rnd;
  bool isBgGen = false;
  Backyard bgYard;
  View activeView = View.home;
  HomeView homeView;
  StartButton startButton;
  LostView lostView;
  Spawner spawner;
  HelpButton helpButton;
  CreditsButton creditsButton;
  HelpView helpView;
  CreditsView creditsView;
  int score;
  int maxScore;
  ScoreDisplay scoreDisplay;
  HighscoreDisplay highscoreDisplay;
  AudioPlayer homeBGM;
  AudioPlayer playingBGM;
  MusicButton musicButton;
  SoundButton soundButton;

  LangawGame(
      // this.storage
      ) {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    flies = <Fly>[];
    rnd = Random();
    score = 0;
    maxScore = 0;
    bgYard = Backyard(this);
    homeView = HomeView(this);
    startButton = StartButton(this);
    musicButton = MusicButton(this);
    soundButton = SoundButton(this);
    lostView = LostView(this);
    spawner = Spawner(this);
    helpButton = HelpButton(this);
    creditsButton = CreditsButton(this);
    helpView = HelpView(this);
    creditsView = CreditsView(this);
    scoreDisplay = ScoreDisplay(this);
    highscoreDisplay = HighscoreDisplay(this);
    homeBGM = await Flame.audio.loopLongAudio('bgm/home.mp3', volume: .25);
    playingBGM =
        await Flame.audio.loopLongAudio('bgm/playing.mp3', volume: .25);
    playHomeBGM();
  }

  void playHomeBGM() {
    playingBGM.pause();
    playingBGM.seek(Duration.zero);
    homeBGM.resume();
  }

  void playPlayingBGM() {
    homeBGM.pause();
    homeBGM.seek(Duration.zero);
    playingBGM.resume();
  }

  void spawnFly() {
    double x = rnd.nextDouble() * (screenSize.width - tileSize * 1.35);
    double y = rnd.nextDouble() * (screenSize.height - tileSize * 2.85) +
        tileSize * 1.5;
    switch (rnd.nextInt(5)) {
      case 0:
        flies.add(HouseFly(this, x, y));
        break;
      case 1:
        flies.add(AgileFly(this, x, y));
        break;
      case 2:
        flies.add(HungryFly(this, x, y));
        break;
      case 3:
        flies.add(DroolerFly(this, x, y));
        break;
      case 4:
        flies.add(MachoFly(this, x, y));
        break;
    }
  }

  void render(Canvas canvas) {
    bgYard.render(canvas); //先渲染背景
    highscoreDisplay.render(canvas);

    flies.forEach((Fly fly) => fly.render(canvas)); //再渲染小飞蝇
    if (activeView == View.home) homeView.render(canvas); //再渲染title
    if (activeView == View.home || activeView == View.lost) {
      startButton.render(canvas);
      helpButton.render(canvas);
      creditsButton.render(canvas);
    }
    if (activeView == View.lost) lostView.render(canvas);

    if (activeView == View.help) helpView.render(canvas);
    if (activeView == View.credits) creditsView.render(canvas);

    if (activeView == View.playing) scoreDisplay.render(canvas);

    musicButton.render(canvas);
    soundButton.render(canvas);
  }

  void update(double t) {
    flies.forEach((Fly fly) => fly.update(t));
    flies.removeWhere((Fly fly) => fly.isOffScreen);

    if (activeView == View.playing) {
      spawner.update(t);
      scoreDisplay.update(t);
    }
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
  }

  void onTapDown(TapDownDetails d) {
    bool isHandled = false; //本次点击事件是否被处理过

    if (!isHandled && (activeView == View.help || activeView == View.credits)) {
      activeView = View.home;
      isHandled = true;
    }

    if (!isHandled && startButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        startButton.onTapDown();
        isHandled = true;
      }
    }

    if (!isHandled && soundButton.rect.contains(d.globalPosition)) {
      soundButton.onTapDown();
      isHandled = true;
    }

    if (!isHandled && musicButton.rect.contains(d.globalPosition)) {
      musicButton.onTapDown();
      isHandled = true;
    }

    if (!isHandled && activeView == View.playing) {
      bool didHitAFly = false;
      flies.forEach((Fly fly) {
        if (fly.flyRect
            .inflate(fly.flyRect.width / 3)
            .contains(d.globalPosition)) {
          fly.onTapDown();
          isHandled = true;
          didHitAFly = true;
        }
      });
      // if (!didHitAFly) {
      //   activeView = View.lost;
      //   if (soundButton.isEnabled)
      //     Flame.audio
      //         .play('sfx/haha' + (rnd.nextInt(5) + 1).toString() + '.ogg');
      //   playHomeBGM();
      // }
    }

    // 教程按钮
    if (!isHandled && helpButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        helpButton.onTapDown();
        isHandled = true;
      }
    }

    // 感谢按钮
    if (!isHandled && creditsButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        creditsButton.onTapDown();
        isHandled = true;
      }
    }
  }
}
