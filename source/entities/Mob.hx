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

class Mob extends MiniEntity
{
    public static inline var SPEED = 60;
    public static inline var SIZE = 15;
    public static inline var HEALTH = 1;

    private var velocity:Vector2;
    private var flashTimer:Alarm;
    private var health:Int;
    private var speed:Float;

    public function new(x:Float, y:Float) {
        super(x, y);
        type = "enemy";
        graphic = Image.createRect(SIZE, SIZE, 0x000000);
        graphic.color = 0x00FFFF;
        mask = new Hitbox(SIZE, SIZE);
        velocity = new Vector2();
        flashTimer = new Alarm(0.1);
        flashTimer.onStart.bind(function() {
        graphic.color = 0xFF0000;
        });
        flashTimer.onComplete.bind(function() {
        graphic.color = 0x00FFFF;
        });
        addTween(flashTimer);
        health = HEALTH;
        speed = SPEED + Math.random() * 10;
    }

    override public function update() {
        velocity = new Vector2(0, -speed);
        velocity.rotate(getAngleTowardsPlayer());
        moveBy(velocity.x * HXP.elapsed, velocity.y * HXP.elapsed);
        super.update();
    }

    public function takeHit() {
        flashTimer.start();
        health -= 1;
        if(health <= 0) {
            die();
        }
    }

    public function die() {
        HXP.scene.remove(this);
        explode(4, 0.75, 0.66, 0.6);
    }
}
