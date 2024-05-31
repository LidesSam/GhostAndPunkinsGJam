package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Santiago Arrieta
 */
class IsoSprite extends FlxSprite 
{
	
	public var body:FlxSprite = null;
	
	public var z:Float;
	
	public var zoffset:Float = 4;
	

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
				body = new FlxSprite();
				zoffset = 4;
		super(X, Y, SimpleGraphic);

		
	}
	
	override public function update(elapsed:Float):Void 
	{
		
		
		super.update(elapsed);
		
		body.x = getMidpoint().x -body.width/2;
		body.y = y - z + height-body.height-zoffset;
	}
	
	
	override public function kill():Void 
	{
		body.kill();
		super.kill();
	}
	override public function draw():Void 
	{
		super.draw();
		
		body.draw();
	}
	
	
	
}