package;

import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.FlxSprite;
import source.Reg;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
/**
 * ...
 * @author Santiago Arrieta
 */
class ElementGenerator extends FlxObject
{

	public var GenSpots:FlxTypedGroup<FlxSprite>;

	private var gencooldown:Float = 0;
	public var eCount:Int = 0;
	public var killCount:Int = 0;
	public var state:PlayState;
	
	
	public var level:Int = 0;
	public var maxEnemies:Array<Int> = [3,5,7];

	public var EnemiesLimit:Array<Int> = [4,8,10];
	
	
	public function new(State:PlayState)
	{
		super();
		GenSpots = new FlxTypedGroup<FlxSprite>();
		gencooldown = 1;
		FlxG.watch.add(this, "eCount", "eCount:");
			FlxG.watch.add(this, "gencooldown", "gencooldown:");
		state = State;
		level=0;
	}
	
	public function getStrOfLevel():String{
		var str:String = "Level:" + (level + 1) + ": Defeated: "+ killCount + "|" + EnemiesLimit[level];
		return str;
	}

	public function addSpot(X:Float=0,Y:Float=0,W:Float,H:Float)
	{
		var spr:FlxSprite = new FlxSprite(X, Y);
		//spr.makeGraphic(Std.int(W), Std.int(H), Reg.fontColor);
		spr.frames = FlxAtlasFrames.fromTexturePackerJson(AssetPaths.adds__png, AssetPaths.adds__json);
		spr.animation.addByPrefix("play", "genspot_", 5);
		spr.animation.play("play");
		spr.resetSizeFromFrame();
		GenSpots.add(spr);
		
		
	}
	override public function update(elapsed:Float):Void
	{
		
			if (gencooldown <= 0)
			{
				if (eCount <= maxEnemies[level] )
				{
					FlxG.log.add(GenSpots.length);
					
					var spot:FlxSprite = cast GenSpots.getRandom();
					
					//spot.color = 0xffff0000;
					//var ex:Float = (Std.random(16) + 1) * 16;
					//var ey:Float = (Std.random(16) + 1) * 16;
					var e:Hazard = new Hazard();
					e.x = spot.getMidpoint().x+e.width/2;
					e.y = spot.getMidpoint().y-e.height/2;
					//FlxG.log.add("ex:"+e.x + "e.y:"+e.y);
					state.hazards.add(e);
					state.add(e.body);
					e.setPlayer(state.getPlayer());
					
					eCount++;

				}
				gencooldown = Std.random(3) + 1;
			}
			else{
				gencooldown -= elapsed;
			}
		super.update(elapsed);
		
		
	}
	
	public function enemydefeated():Void{
		killCount++;
		eCount--;
	}

}