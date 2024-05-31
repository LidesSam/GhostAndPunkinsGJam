package;
import flixel.FlxG;
import flixel.FlxState;
import source.Reg;

import flixel.text.FlxText;
/**
 * ...
 * @author Santiago Arrieta
 */
class GameOverState extends FlxState
{
	var GameOverMsg:FlxText;
	var startMsg:FlxText;
		var scoreMsg:FlxText;
	override public function create():Void{
		Reg.controlDef();
	
		FlxG.sound.pause();
		bgColor = Reg.backgroundMenuColor;
		GameOverMsg = new FlxText(0, 0);
		GameOverMsg.text = "GameOver";
			
		GameOverMsg.size=24;
		GameOverMsg.x = FlxG.width / 2 - GameOverMsg.width / 2;
		GameOverMsg.color = Reg.fontColor;
		GameOverMsg.setBorderStyle(FlxTextBorderStyle.OUTLINE, Reg.fontOutlineColor, 4);
		GameOverMsg.y = FlxG.height/3;
		//GameOverMsg.y = 128;
	
		
				
		scoreMsg = new FlxText(0, 0);
		scoreMsg.text = "Score: "+Reg.finalScore;
		//startMsg.screenCenter();
		scoreMsg.y= GameOverMsg.y+GameOverMsg.height + 48;
		scoreMsg.x = FlxG.width / 2 - scoreMsg.width / 2;
		//FlxG.debugger.visible = true;
		
		scoreMsg.color = Reg.fontColor;
		scoreMsg.setBorderStyle(FlxTextBorderStyle.OUTLINE, Reg.fontOutlineColor, 1);
		
		startMsg = new FlxText(0, 0);
		startMsg.text = "Press Start";
		//startMsg.screenCenter();
		startMsg.y=scoreMsg.y+scoreMsg.height + 8;
			startMsg.x = FlxG.width / 2 - startMsg.width / 2;
		//FlxG.debugger.visible = true;
		
		startMsg.color = Reg.fontColor;
		startMsg.setBorderStyle(FlxTextBorderStyle.OUTLINE, Reg.fontOutlineColor, 1);
		
		add(GameOverMsg);
		add(scoreMsg);
		add(startMsg);
		
		bgColor = Reg.backgroundMenuColor;
		//
		
		FlxG.sound.playMusic(AssetPaths.chord_1__wav, 0.4);
		
		//FlxG.sound.music.loadEmbedded(AssetPaths.chord_1__wav);
		//FlxG.sound.music.play();
		//FlxG.sound.music.volume = 0.3;	
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (Reg.startPress.triggered || Reg.actionPress.triggered)
		{
			FlxG.camera.fade(Reg.fontColor, 2, false, function (){FlxG.switchState(new MainMenuState()); });
			FlxG.sound.play(AssetPaths.pitch_lauching__wav);
		}
		Reg.UpdateControl();
		
		
		super.update(elapsed);
	
	}
	
}