import 'dart:ui';
import 'package:langaw/components/fly.dart';
import 'package:langaw/langaw-game.dart';

class Spawner {
  final LangawGame game;
  final int maxSpawnInterval = 1500; //最多每3秒钟生成一只小飞蝇
  final int minSpawnInterval = 250; //最少每250毫秒生成一个小飞蝇
  final int intervalChange = 3; //生成小飞蝇的interval增长速度
  final int maxFliesOnScreen = 5; //屏幕上最多可存活的小飞蝇的数量
  int currentInterval; //当前生成小飞蝇的速度
  int nextSpawn; //下一次生成小飞蝇的时间戳

  Spawner(this.game) {
    start();
    game.spawnFly();
  }

  void update(double t) {
    int nowTimestamp = DateTime.now().millisecondsSinceEpoch;

    int liveFlies = 0;
    game.flies.forEach((Fly fly) {
      if (!fly.isDead) liveFlies += 1;
    });

    if (nowTimestamp >= nextSpawn && liveFlies < maxFliesOnScreen) {
      game.spawnFly();
      if (currentInterval > minSpawnInterval) {
        currentInterval -= intervalChange;
        currentInterval -= (currentInterval * 0.015).toInt();
      }

      nextSpawn = currentInterval + nowTimestamp;
    }
  }

  void start() {
    killAll();
    currentInterval = maxSpawnInterval;
    nextSpawn = DateTime.now().millisecondsSinceEpoch + currentInterval;
  }

  void killAll() {
    game.flies.forEach((Fly fly) => fly.isDead = true);
  }
}
