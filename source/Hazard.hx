package;

//import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxG;
//import flixel.math.FlxRandom;
//import flixel.addons.util.FlxFSM;
import flixel.math.FlxAngle;

import flixel.addons.util.FlxFSM;
/**
 * ...
 * @author Santiago Arrieta
 */
class Hazard extends IsoSprite
{

	private var dmgcooldown:Float = 0;
	public var movecooldown:Float = 0;
	
	
	private var maxLifepoint:Int = 3;
	private var lifepoint:Int = 3;
	
	private var fsm:FlxFSM<Hazard>;
	private var player:Player = null;
	//private var body:
	
	
	public var detectionRange:Float = 100;
	public var atkRange:Float = 100;
	
	
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		//makeGraphic(24, 24, FlxColor.RED);
		frames = FlxAtlasFrames.fromTexturePackerJson(AssetPaths.enemies__png, AssetPaths.enemies__json);
		animation.addByPrefix("play", "shadow_",0);
		animation.play("play");
		resetSizeFromFrame();
		
		body.frames = FlxAtlasFrames.fromTexturePackerJson(AssetPaths.enemies__png, AssetPaths.enemies__json);
		body.animation.addByPrefix("stand", "rot-pumpkin_", 4);
			body.animation.addByPrefix("hunt", "rot-pumpkin_", 8);
		body.animation.addByPrefix("death", "rot-pumpkin-death_",  4);
		body.animation.play("stand");
		body.resetSizeFromFrame();
		
		zoffset = 12;
		solid  = false;
		elasticity = 1;
		fsm = new FlxFSM<Hazard>(this);
		fsm.transitions.addGlobal(EDeathState, Enemy_Conditions.death);
		fsm.transitions.add(EStandState, ESeekState, Enemy_Conditions.playerInDetectionRange);
		fsm.transitions.add(ESeekState, EStandState, Enemy_Conditions.playerOutDetectionRange);
		
		//f
		//fsm.transitions.add(EDeathState, Enemy_Conditions.death);
		
		fsm.transitions.start(EStandState);
		
		lifepoint = 1;
	}
	
	
	
	override public function update(elapsed:Float):Void 
	{
		
		fsm.update(elapsed);
				//velocity.set(0, 0);
		super.update(elapsed);
		//velocity.set(0, 0);
		
		
		if (dmgcooldown > 0){dmgcooldown -= 0; }
		
		
		//worldLimits();
	}
	
	public function randMove(elapsed:Float):Void{
		if (movecooldown > 0){movecooldown -= elapsed; }else{
			body.animation.play("stand");
			solid = true;
			movecooldown =  Std.random(3);
			velocity.x = FlxG.random.int( -1, 1) * (25+25*Std.random(3));
			velocity.y = FlxG.random.int(-1, 1) * (25+25*Std.random(3));
		}
		
		
	}
	
	public function SeekMove(elapsed:Float):Void{
		if (movecooldown > 0){movecooldown -= elapsed; }
		else{
			solid = true;
			body.animation.play("hunt");
			movecooldown = 1.5;
			//velocity.x = FlxG.random.int( -1, 1) * (25+25*Std.random(3));
			//velocity.y = FlxG.random.int( -1, 1) * (25 + 25 * Std.random(3));
			
			var angle_to_player:Float = FlxAngle.angleBetween(player, this, true) +180;
			velocity.x = Math.cos(angle_to_player * FlxAngle.TO_RAD) * 120;
			velocity.y = Math.sin(angle_to_player * FlxAngle.TO_RAD) * 120;
		}
		
		
	}
	
	override public function draw():Void 
	{
		super.draw();
		body.draw();
	}
	
	
	//public function worldLimits(){
			//
		//if (x <= 0){x = 0; velocity.x *=-1; }
		//if (x + width >= FlxG.width){x = FlxG.width - width; velocity.x *=-1; }
		//if (y <= 0){y = 0;velocity.y *=-1;  }
		//if (y+height >= FlxG.height){y = FlxG.height-height; velocity.y *=-1;  }
	//}
	
	public function dmg(Points:Int=1){
		lifepoint -= Points;
		
	}
	
	public function getLifepoints():Int{
		return lifepoint;
	}
	public function getMaxLifepoints():Int{
		return maxLifepoint;
	}
	public function setPlayer(P:Player){
		player = P;
	}
	
	public function getDistanceToPlayer():Float
	{

		var nx = getGraphicMidpoint().x - player.getMidpoint().x ;
		var ny = getGraphicMidpoint().y - player.getMidpoint().y ;
		var d = Math.abs(Math.sqrt(Math.pow(nx, 2) + Math.pow(ny, 2)));
		return d;
	}
	
}

class Enemy_Conditions{
	public static function death(owner:Hazard ){
		var check:Bool = false;
		if(owner.getLifepoints()<=0){
			check = true;
		}
		return	check;
	}
	
	
	public static function playerInAtkRange(Owner:Hazard):Bool
	{
		var check:Bool = false;
		var d = Owner.getDistanceToPlayer();
		if (d <= Owner.atkRange)
		{
			check = true;

		}
		return check;
	}
	
	public static function playerOutAtkRange(Owner:Hazard):Bool
	{
		
		return !playerInAtkRange(Owner);
	}
	
	public static function playerInDetectionRange(Owner:Hazard):Bool
	{
		var check:Bool = false;
		var d = Owner.getDistanceToPlayer();
		if (d <= Owner.detectionRange)
		{
			check = true;

		}
		return check;
	}
	
	public static function playerOutDetectionRange(Owner:Hazard):Bool
	{
		
		return !playerInDetectionRange(Owner);
	}
	
	
}


class EPreStartState extends FlxFSMState<Hazard>
{

	override public function enter(owner:Hazard, fsm:FlxFSM<Hazard>):Void
	{
			owner.color = FlxColor.RED;
			owner.solid = false;
	}

	override public function update(elapsed:Float, owner:Hazard, fsm:FlxFSM<Hazard>):Void
	{
		
	}
	
	override public function exit(owner:Hazard):Void 
	{
		owner.solid = false;
		owner.color = FlxColor.WHITE;
		 super.exit(owner);
	}
}

class EStandState extends FlxFSMState<Hazard>
{

	override public function enter(owner:Hazard, fsm:FlxFSM<Hazard>):Void
	{
		
	}

	override public function update(elapsed:Float, owner:Hazard, fsm:FlxFSM<Hazard>):Void
	{
		
	
		owner.randMove(elapsed);
	}
}

class EDeathState extends FlxFSMState<Hazard>
{

	override public function enter(owner:Hazard, fsm:FlxFSM<Hazard>):Void
	{
		owner.solid = false;
		owner.velocity.set(0, 0);
		
		var state:PlayState = cast FlxG.state;
		state.generator.eCount -= 1;
		state.generator.killCount -= 1;
		
		owner.body.animation.play("death");
		FlxG.watch.add(owner, "z", "z:");
		owner.visible = false;
		
		FlxG.sound.play(AssetPaths.foe_death1__wav);
	}

	override public function update(elapsed:Float, owner:Hazard, fsm:FlxFSM<Hazard>):Void
	{
		owner.z += 10 * elapsed;
		
		if (owner.z > 50){
			owner.color = 0xffff0000;
			owner.kill();
		}
	}
}

class ESeekState extends FlxFSMState<Hazard>
{

	
	
	override public function enter(owner:Hazard, fsm:FlxFSM<Hazard>):Void
	{
		owner.solid = false;
		owner.velocity.set(0, 0);
		
		var state:PlayState = cast FlxG.state;
		state.generator.eCount -= 1;
		state.generator.killCount -= 1;
		
		owner.movecooldown = 0.25;
		
		//owner.bodyani.play("death");
		
	}

	override public function update(elapsed:Float, owner:Hazard, fsm:FlxFSM<Hazard>):Void
	{
		
		
			owner.SeekMove(elapsed);
	}
}

class EShotState extends FlxFSMState<Hazard>
{

	override public function enter(owner:Hazard, fsm:FlxFSM<Hazard>):Void
	{
		//owner.solid = false;
		//owner.velocity.set(0, 0);
		//
		//var state:PlayState = cast FlxG.state;
		//state.generator.eCount -= 1;
		//state.generator.killCount -= 1;
		//
		//owner.body.Q!play("death");
		
	}

	override public function update(elapsed:Float, owner:Hazard, fsm:FlxFSM<Hazard>):Void
	{
		//owner.z += 10 * elapsed;
		//
		//if(owner.z>50){
			//owner.kill();
		//}
	}
}