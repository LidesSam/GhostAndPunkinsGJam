package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.text.FlxText;
import source.Reg;

/**
 * ...
 * @author Santiago Arrieta
 */
class Hud extends FlxTypedGroup<FlxSprite>
{
	private var atlas:FlxAtlasFrames;
	private var portrait:FlxSprite;
	private var player:Player;
	private var lifebar:Array<FlxSprite>;
	private var state:PlayState;
	private var Level:FlxText;
	
	private var score:FlxText; 
	
	public function new(P:Player, State:PlayState)
	{
		super();
		
		player = P;
		state = State;
		atlas =  FlxAtlasFrames.fromTexturePackerJson(AssetPaths.adds__png,AssetPaths.adds__json);
			
		portrait = new FlxSprite(8, 8);
		portrait.frames = atlas;
		portrait.animation.addByNames("play",["girl-portrait.png"],0);
		portrait.animation.play("play");
		portrait.resetSizeFromFrame();
		add(portrait);
		
		lifebar = new Array<FlxSprite>();
		
		for(i in 0...player.getMaxLifepoints()){
			var lp:FlxSprite = new FlxSprite(portrait.x + portrait.width + 4, portrait.getGraphicMidpoint().y);
			lp.frames = atlas;
			lp.animation.addByNames("on",["pumpkinpoint_0.png"]);
			lp.animation.addByNames("off",["pumpkinpoint_1.png"]);
			lp.animation.play("on");
			lp.resetSizeFromFrame();
			
			lp.x += lp.width * i;
			lp.y -= lp.height / 2;
			lifebar.push(lp);
			
			add(lp);
		}
		FlxG.log.add("lp" + lifebar.length);
		
		score = new  FlxText(0, 16);
		score.text = "score:000000";
		score.x = FlxG.width -score.width - 2;
		
			score.color = Reg.fontColor;

		score.setBorderStyle(FlxTextBorderStyle.OUTLINE, Reg.fontOutlineColor, 1);
		add(score);
		
		Level = new FlxText(0, 16);
		Level.color = Reg.fontColor;
		Level.setBorderStyle(FlxTextBorderStyle.OUTLINE, Reg.fontOutlineColor, 1);
		//add(Level);
		
		forEach(function(spr:FlxSprite)
		{
			spr.scrollFactor.set(0, 0);
		});
		
		
		
		
	}
	
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		var count:Int = 0;
		for (lp in lifebar){
			count++;
			if (count>player.getMaxLifepoints()){
				lp.visible = false;
			}else{
				if(count>player.getLifepoints()){
					lp.animation.play("off");
				}else{
					lp.animation.play("on");
				}
			}
			
		
		}
		
				score.text = state.getStrOfScore();
		Level.text = state.generator.getStrOfLevel();
		Level.x = score.x - 4 - Level.width;
		
		

		
	}
	
	
	
}