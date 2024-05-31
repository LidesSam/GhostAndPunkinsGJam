package;

import flixel.FlxSprite;
import flixel.addons.weapon.FlxBullet;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.addons.util.FlxFSM;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import source.Reg;
import flixel.graphics.frames.FlxAtlasFrames;
/**
 * ...
 * @author Santiago Arrieta
 */
class Player extends IsoSprite//FlxSprite
{

	private var maxLifepoint:Int = 3;
	private var lifepoint:Int = 3;

	private var cooldown:Float = 0;
	private var noDmgCooldown:Float = 0;

	public var recoilFlag:Bool;
	public var StateEnd:Bool;

	//public var body:FlxSprite;

	//public var z:Float = 0;

	private var fsm:FlxFSM<Player>;
	//private var bullets:FlxTypedGroup<Bullet>;

	public var world:PlayState;
	public var stage:TiledLevel;

	private var dir:Int;

	private var dirx:Int;
	private var diry:Int;

	private var vdir:FlxPoint;

	public var bullets:FlxTypedGroup<FlxSprite>;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);
		makeGraphic(16, 16,0xff000000);

		maxLifepoint = 3;
		lifepoint = maxLifepoint;
		//lifepoint = 1;

		maxVelocity.set(200, 200 );
		drag.set(120, 120);

		frames = FlxAtlasFrames.fromTexturePackerJson(AssetPaths.girlsheet__png, AssetPaths.girlsheet__json);
		animation.addByNames("0", ["girl-shadow_2.png"]);
		animation.play("0");
		width = 16;
		height = 16;

		centerOffsets();

		body = new FlxSprite();
		body.frames = FlxAtlasFrames.fromTexturePackerJson(AssetPaths.girlsheet__png, AssetPaths.girlsheet__json);

		LoadBodyAnimations();
		body.animation.play("stand-front");
		body.solid = false;
		body.height = 24;
		body.width = 16;
		body.centerOffsets();
		z = 0;
		//fsm = new FlxFSM<player>(this);

		fsm = new FlxFSM(this);
		fsm.transitions.addGlobal(DeathState, Conditions.Death);
		fsm.transitions.addGlobal(RecoilState, Conditions.Recoil);
		fsm.transitions.add(RecoilState,StandState, Conditions.StateFinished);
		fsm.transitions.start(StandState);

		dir = 0;
		bullets = new FlxTypedGroup<FlxSprite>();

		vdir = new FlxPoint(0, 150 );

		recoilFlag = false;
		StateEnd = false;
		zoffset = 12;
	}

	public function getDir():Int
	{
		return dir;
	}

	override public function update(elapsed:Float):Void
	{

		fsm.update(elapsed);

		super.update(elapsed);

		//body.x = getMidpoint().x - body.width / 2;
		//body.y = getMidpoint().y - body.height - z - 4;

		if (noDmgCooldown>0)
		{
			noDmgCooldown -= elapsed;
		}

		//omniMovement(elapsed);
	}

	public function omniMovement(elapsed:Float)
	{
		// back images
		//if (Reg.upPress.triggered)
		if (Reg.up.triggered)
		{
			velocity.y =-100;
			//acceleration.y =-100;
			vdir.y =-200;
			dir = 4;
			if (Reg.right.triggered)
			{
				dir = 3;
			}
			else
			{
				if (Reg.left.triggered)
				{
					dir = 5;
				}
			}

		}

		//front image
		//if (Reg.downPress.triggered)
		if (Reg.down.triggered)
		{
			velocity.y = 100;
			//acceleration.y = 100;
			dir = 0;
			vdir.y =200;
			if (Reg.right.triggered)
			{
				dir = 1;
			}
			else
			{
				if (Reg.left.triggered)
				{
					dir = 7;
				}

			}
		}

		//if (Reg.rightPress.triggered)
		if (Reg.right.triggered)
		{
			velocity.x =100;
			//acceleration.x = 100;
			dir = 2;
			vdir.x = 200;
			if (Reg.down.triggered)
			{
				dir = 1;
			}
			else
			{
				if (Reg.up.triggered)
				{
					dir = 3;
				}
			}

		}

		//if (Reg.leftPress.triggered)
		if (Reg.left.triggered)
		{
			velocity.x =-100;
			//acceleration.x =-100;
			dir = 6;
			vdir.x =-200;
			if (Reg.down.triggered)
			{
				dir = 7;
			}
			else
			{
				if (Reg.up.triggered)
				{
					dir = 5;
				}

			}

		}

		//conditions to stop
		//if (velocity.y != 0 && !Reg.up.triggered && !Reg.down.triggered){
		if (!Reg.up.triggered && !Reg.down.triggered)
		{
			velocity.y = 0;
			//acceleration.y = 0;
			vdir.y = 0;

		}
		//if(velocity.x!=0 && !Reg.right.triggered && !Reg.left.triggered){
		if ( !Reg.right.triggered && !Reg.left.triggered )
		{
			velocity.x = 0;
			//acceleration.x = 0;
			vdir.x = 0;

		}

		if (!Reg.up.triggered && !Reg.down.triggered && !Reg.right.triggered && !Reg.left.triggered)
		{
			switch (dir)
			{
				case 0:  vdir.set(0, 200);
				case 1:  vdir.set(200, 200);
				case 2:  vdir.set(200, 0);
				case 3:  vdir.set(200, -200);
				case 4:  vdir.set(0, -200);
				case 5:  vdir.set(-200, -200);
				case 6:  vdir.set( -200, 0);
				case 7: vdir.set(-200, 200);
				default:
					vdir.set(0,200);

			}
			AnimationPlay("stand");//discoment after add animation walk

		}
		else
		{
			AnimationPlay("walk");//discoment after add animation walk

		}

		//AnimationPlay("stand");//comment after add animation walk
		//worldLimits();

	}
	//cheche limits
	public function worldLimits()
	{

		if (x <= 0) {x = 0;  acceleration.x = 0; x += 1; }
		if (x + width > FlxG.width) {x = FlxG.width - width; acceleration.x = 0; x -= 1;}
		if (y < 0) {y = 0; acceleration.y = 0; y += 1; }
		//if (y + height > FlxG.height){y = FlxG.height - height; acceleration.y = 0; y -= 1;}
		if (y + height > FlxG.height) {y = FlxG.height - height; acceleration.y = 0; y -= 1;}
	}

	public function shotBullet()
	{
		if (Reg.actionPress.triggered)
		{
			var bullet:FlxSprite = new FlxSprite();
			bullet.frames = FlxAtlasFrames.fromTexturePackerJson(AssetPaths.adds__png, AssetPaths.adds__json);
			bullet.animation.addByNames("play", ["ball_0.png"]);
			bullet.animation.play("play");
			bullet.resetSizeFromFrame();

			bullet.x = getMidpoint().x - bullet.width / 2;
			bullet.y = getMidpoint().y - bullet.height / 2;
			bullet.velocity.set(vdir.x, vdir.y);
			FlxG.sound.play(AssetPaths.BackSelect__wav);
			bullets.add(bullet);

		}
	}

	/**
	 * quick way to damage the player
	 * @param	points damage recibed
	 */
	public function dmg(points:Int=1):Void
	{
		if (noDmgCooldown<=0)
		{
			lifepoint -= points;
			if (lifepoint < 0) {lifepoint = 0; }
		
			

		}else{
				noDmgCooldown = 2;
		}
		
		FlxG.sound.play(AssetPaths.girl_hurt_1__wav);
		recoilFlag = true;

	}
	/**
	 * quick way to heal the player
	 * @param	points damage recibed
	 */
	public function heal(points:Int=1):Void
	{
		lifepoint += points;
		if (lifepoint>maxLifepoint)
		{
			lifepoint = maxLifepoint;
		}
	}

	public function getLifepoints():Int
	{
		return lifepoint;
	}
	public function getMaxLifepoints():Int
	{
		return maxLifepoint;
	}

	/**
	 * auxiliary function for more clean code.
	 */
	private function LoadBodyAnimations()
	{
		//stand
		body.animation.addByPrefix("stand-front", "girl-stand-front_");

		body.animation.addByPrefix("stand-rfront", "girl-stand-rfront_");

		body.animation.addByPrefix("stand-right", "girl-stand-r_");

		body.animation.addByPrefix("stand-rback", "girl-stand-rback_");

		body.animation.addByPrefix("stand-back", "girl-stand-back_");

		body.animation.addByPrefix("stand-lback", "girl-stand-lback_");

		body.animation.addByPrefix("stand-left", "girl-stand-l_");

		body.animation.addByPrefix("stand-lfront", "girl-stand-lfront_");

		//walk

		body.animation.addByPrefix("walk-front", "girl-walk-front_",8);

		body.animation.addByPrefix("walk-rfront", "girl-walk-rfront_",8);

		body.animation.addByPrefix("walk-right", "girl-walk-right_",8);

		body.animation.addByPrefix("walk-rback", "girl-walk-rback_",8);

		body.animation.addByPrefix("walk-back", "girl-walk-back_",8);

		body.animation.addByPrefix("walk-lback", "girl-walk-lback_",8);

		body.animation.addByPrefix("walk-left", "girl-walk-left_",8);

		body.animation.addByPrefix("walk-lfront", "girl-walk-lfront_",8);

		//kneel
		body.animation.addByPrefix("kneel-front", "girl-kneel-front_");

		body.animation.addByPrefix("kneel-rfront", "girl-kneel-rfront_");

		body.animation.addByPrefix("kneel-right", "girl-kneel-r_");

		body.animation.addByPrefix("kneel-rback", "girl-kneel-rback_");

		body.animation.addByPrefix("kneel-back", "girl-kneel-back_");

		body.animation.addByPrefix("kneel-lback", "girl-kneel-lback_");

		body.animation.addByPrefix("kneel-left", "girl-kneel-l_");

		body.animation.addByPrefix("kneel-lfront", "girl-kneel-lfront_");

		//death
		body.animation.addByPrefix("death", "girl-ghost_");

	}

	//use to short code
	public function AnimationPlay(AnimName:String ="stand")
	{
		switch (AnimName)
		{
			case "stand":
				switch (dir)
				{
					case 0: body.animation.play("stand-front");
					case 1:	body.animation.play("stand-rfront");
					case 2: body.animation.play("stand-right");
					case 3:	body.animation.play("stand-rback");
					case 4: body.animation.play("stand-back");
					case 5:	body.animation.play("stand-lback");
					case 6: body.animation.play("stand-left");
					case 7:	body.animation.play("stand-lfront");
				}
			case "walk":
				switch (dir)
				{
					case 0: body.animation.play("walk-front");
					case 1:	body.animation.play("walk-rfront");
					case 2: body.animation.play("walk-right");
					case 3:	body.animation.play("walk-rback");
					case 4: body.animation.play("walk-back");
					case 5:	body.animation.play("walk-lback");
					case 6: body.animation.play("walk-left");
					case 7:	body.animation.play("walk-lfront");
				}
			case "kneel":
				switch (dir)
				{
					case 0: body.animation.play("kneel-front");
					case 1:	body.animation.play("kneel-rfront");
					case 2: body.animation.play("kneel-right");
					case 3:	body.animation.play("kneel-rback");
					case 4: body.animation.play("kneel-back");
					case 5:	body.animation.play("kneel-lback");
					case 6: body.animation.play("kneel-left");
					case 7:	body.animation.play("kneel-lfront");
				}

		}
	}

}

class Conditions
{
	public static function Death(owner:Player):Bool
	{
		var check = false;
		if (owner.getLifepoints() <= 0)
		{
			check = true;
		}
		return check;
	}

	public static function Recoil(owner:Player):Bool
	{
		return owner.recoilFlag;
	}

	public static function StateFinished(owner:Player):Bool
	{
		return owner.StateEnd;
	}
}

class StandState extends FlxFSMState<Player>
{

	override public function enter(owner:Player, fsm:FlxFSM<Player>):Void
	{
		//owner.animation.play("standing");
		//if (owner.haveBlock())
		//{
		//owner.animation.play("standblock");
		//}
	}

	override public function update(elapsed:Float, owner:Player, fsm:FlxFSM<Player>):Void
	{
		//if (owner.haveBlock())
		//{
		//owner.lateralmovement("walkblock","standblock");
		//}
		//else{
		//owner.lateralmovement("walking", "standing");
//
		//}

		owner.omniMovement(elapsed);
		owner.shotBullet();
		//super.update(elapsed,owner,);
	}
}

class RecoilState extends FlxFSMState<Player>
{

	var cooldown:Float = 0;
	
	override public function enter(owner:Player, fsm:FlxFSM<Player>):Void
	{
		//owner.animation.play("standing");
		//if (owner.haveBlock())
		//{
		//owner.animation.play("standblock");
		//}
		//cooldown = 2;
		owner.recoilFlag = false;

		cooldown = 0.5;
		switch (owner.getDir())
		{

			case 0:
				//owner.body.animation.play("stand-front");
				owner.velocity.set(0, -100);
			case 1:
				//owner.body.animation.play("stand-rfront");
				owner.velocity.set( -100, -100);
			case 2:
				//owner.body.animation.play("stand-right");
				owner.velocity.set( -100, 0);
			case 3:
				//owner.body.animation.play("stand-rback");
				owner.velocity.set( -100, 100);
			case 4:
				//owner.body.animation.play("stand-back");
				owner.velocity.set( 0,100);
			case 5:
				//owner.body.animation.play("stand-lback");
				owner.velocity.set( 100, 100);
			case 6:
				//owner.body.animation.play("stand-left");
				owner.velocity.set( 100,100);
			case 7:
				//owner.body.animation.play("stand-lfront");
				owner.velocity.set( 100, -100);
		}

		owner.AnimationPlay("kneel");
	}

	override public function update(elapsed:Float, owner:Player, fsm:FlxFSM<Player>):Void
	{
		if (owner.velocity.x ==0 && owner.velocity.y==0|| cooldown<=0)
		{
			owner.StateEnd = true;
		}
		
		if(cooldown>0){
		cooldown -= elapsed;
		}
	}
	override public function exit(owner:Player):Void
	{

		owner.StateEnd = false;
		owner.recoilFlag = false;
		owner.AnimationPlay("stand");
		super.exit(owner);
	}
}

class DeathState extends FlxFSMState<Player>
{

	override public function enter(owner:Player, fsm:FlxFSM<Player>):Void
	{
		//owner.animation.play("standing");
		//if (owner.haveBlock())
		//{
		//owner.animation.play("standblock");
		//}
		FlxG.camera.fade(Reg.backgroundMenuColor, 2, false, owner.world.GameOver);
		owner.solid = false;
		owner.body.animation.play("death");
		owner.acceleration.set(0, 0);
		owner.velocity.set(0, 0);
		
		//owner.color = FlxColor.RED;
		FlxG.sound.play(AssetPaths.pitch_lauching__wav, 1, true);

	}

	override public function update(elapsed:Float, owner:Player, fsm:FlxFSM<Player>):Void
	{
		//if (owner.haveBlock())
		//{
		//owner.lateralmovement("walkblock","standblock");
		//}
		//else{
		//owner.lateralmovement("walking", "standing");
//
		//}
		//owner.omniMovement(elapsed:Float);
		owner.z += 25 * elapsed;
	}

	override public function exit(owner:Player):Void
	{

		super.exit(owner);
	}
}