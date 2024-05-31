package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.graphics.frames.FlxAtlasFrames;
/**
 * ...
 * @author Santiago Arrieta
 */
class Item extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		frames = FlxAtlasFrames.fromTexturePackerJson("assets/images/adds.png", "assets/images/adds.json");
		
		animation.addByNames("play", ["pumpkin-pie_0.png"]);
		animation.play("play");
		
		resetSizeFromFrame();
	}
	
}