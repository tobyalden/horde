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

    override public function begin() {
        var level = new Level("level");
        add(level);
        for(entity in level.entities) {
            add(entity);
        }
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
