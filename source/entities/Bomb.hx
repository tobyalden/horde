package entities;

import haxepunk.*;
import haxepunk.graphics.*;
import haxepunk.input.*;
import haxepunk.masks.*;
import haxepunk.math.*;
import haxepunk.Tween;
import haxepunk.tweens.misc.*;
import haxepunk.utils.*;
import scenes.*;

class Bomb extends MiniEntity
{
    public static inline var FUSE_TIME = 5;
    public static inline var RADIUS = 25;

    private var fuse:Alarm;
    private var sprite:Image;

    public function new(x:Float, y:Float, radius:Int) {
        super(x, y);
        type = "bomb";
        sprite = Image.createCircle(radius, 0xFF0000);
        sprite.centerOrigin();
        sprite.alpha = 0.1;
        sprite.color = 0xFF0000;
        graphic = sprite;
        var hitbox = new Circle(radius);
        hitbox.x = Std.int(-halfWidth);
        hitbox.y = Std.int(-halfHeight);
        mask = hitbox;
        fuse = new Alarm(FUSE_TIME);
        fuse.onComplete.bind(function() {
            detonate();
        });
        addTween(fuse, true);
    }

    override public function update() {
        sprite.alpha = MathUtil.lerp(0.1, 1, Ease.expoIn(fuse.percent));
        super.update();
    }

    private function detonate() {
        var mobs = [];
        collideTypesInto(["enemy"], x, y, mobs);
        for(mob in mobs) {
            cast(mob, Mob).die();
        }
        if(collide("player", x, y) != null) {
            var player = scene.getInstance("player");
            cast(player, Player).die();
        }
        HXP.scene.remove(this);
        explode();
    }
}

