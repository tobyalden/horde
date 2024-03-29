package entities;

import haxepunk.*;
import haxepunk.graphics.*;
import haxepunk.masks.*;
import haxepunk.math.*;
import haxepunk.Tween;
import haxepunk.tweens.misc.*;
import haxepunk.utils.*;
import scenes.*;

typedef BulletOptions = {
    @:optional var width:Int;
    @:optional var height:Int;
    @:optional var radius:Int;
    var angle:Float;
    var speed:Float;
    var shotByPlayer:Bool;
    var collidesWithWalls:Bool;
    @:optional var bulletType:String;
    @:optional var callback:Bullet->Void;
    @:optional var callbackDelay:Float;
    @:optional var color:Int;
    @:optional var gravity:Float;
}

class Bullet extends MiniEntity
{
    public var velocity:Vector2;
    public var sprite:Image;
    public var angle:Float;
    public var speed:Float;
    public var gravity:Float;
    public var bulletOptions:BulletOptions;

    public function new(x:Float, y:Float, bulletOptions:BulletOptions) {
        if(bulletOptions.shotByPlayer) {
            super(x - bulletOptions.width / 2, y - bulletOptions.height / 2);
        }
        else {
            super(x - bulletOptions.radius, y - bulletOptions.radius);
        }
        this.bulletOptions = bulletOptions;
        type = bulletOptions.shotByPlayer ? "playerbullet" : "hazard";
        this.angle = bulletOptions.angle - Math.PI / 2;
        this.speed = bulletOptions.speed;
        //type = "hazard";
        var color = bulletOptions.color == null ? 0xFFFFFF : bulletOptions.color;
        gravity = bulletOptions.gravity == null ? 0 : bulletOptions.gravity;
        if(bulletOptions.shotByPlayer) {
            mask = new Hitbox(bulletOptions.width, bulletOptions.height);
            sprite = Image.createRect(width, height, color);
        }
        else {
            mask = new Circle(bulletOptions.radius);
            sprite = Image.createCircle(bulletOptions.radius, color);
        }
        graphic = sprite;
        velocity = new Vector2();
        var callbackDelay = (
            bulletOptions.callbackDelay == null ? 0 : bulletOptions.callbackDelay
        );
        if(bulletOptions.callback != null) {
            addTween(new Alarm(callbackDelay, function() {
                bulletOptions.callback(this);
            }), true);
        }
        velocity.x = Math.cos(angle);
        velocity.y = Math.sin(angle);
        velocity.normalize(speed);
    }

    override public function moveCollideX(_:Entity) {
        onCollision();
        return true;
    }

    override public function moveCollideY(_:Entity) {
        onCollision();
        return true;
    }

    private function onCollision() {
        scene.remove(this);
        explode(2, 0.5, 0.33, 0.3);
    }

    override public function update() {
        velocity.y += gravity * HXP.elapsed;
        if(bulletOptions.collidesWithWalls) {
            moveBy(velocity.x * HXP.elapsed, velocity.y * HXP.elapsed, "walls");
        }
        else {
            moveBy(velocity.x * HXP.elapsed, velocity.y * HXP.elapsed);
        }
        if(bulletOptions.shotByPlayer) {
            var enemy = collide("enemy", x, y);
            if(enemy != null) {
                cast(enemy, Mob).takeHit();
                onCollision();
            }
        }
        if(!collideRect(
            x, y, scene.camera.x, scene.camera.y, HXP.width, HXP.height)
        ) {
            scene.remove(this);
        }
        super.update();
    }
}

