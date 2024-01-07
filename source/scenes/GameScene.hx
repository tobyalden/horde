package scenes;

import entities.*;
import haxepunk.*;
import haxepunk.graphics.*;
import haxepunk.graphics.tile.*;
import haxepunk.input.*;
import haxepunk.masks.*;
import haxepunk.math.*;
import haxepunk.Tween;
import haxepunk.tweens.misc.*;
import haxepunk.utils.*;
import openfl.Assets;

class GameScene extends Scene
{
    public static inline var GAME_WIDTH = 640;
    public static inline var GAME_HEIGHT = 360;

    private var enemySpawner:Alarm;
    private var bombSpawner:Alarm;

    override public function begin() {
        var level = new Level("level");
        add(level);
        for(entity in level.entities) {
            add(entity);
        }
        enemySpawner = new Alarm(0.2, function() {
            for(i in 0...Random.randInt(3)) {
                var mob = new Mob(320, 320);
                mob.moveBy(-mob.halfWidth, -mob.halfHeight);
                var displacer = new Vector2(320, 320);
                displacer.rotate(Math.random() * Math.PI * 2);
                mob.moveBy(displacer.x, displacer.y);
                add(mob);
            }
        }, TweenType.Looping);
        addTween(enemySpawner, true);
        bombSpawner = new Alarm(2.5, function() {
            var bomb = new Bomb(GAME_WIDTH * Random.random, GAME_HEIGHT * Random.random, 40 + Random.randInt(40));
            add(bomb);
        }, TweenType.Looping);
        addTween(bombSpawner, true);
    }

    override public function update() {
        super.update();
    }

    public function onDeath() {
        HXP.alarm(1, function() {
            HXP.scene = new GameScene();
        });
    }
}
