package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import source.Reg;
import flixel.FlxG;
/**
 * ...
 * @author Santiago Arrieta
 */
class MainMenuState extends FlxState
{
	private var title:FlxText;
	private var startMsg:FlxText;
	private var state = 0;
	private var versionMsg:FlxText;
	private var logo:FlxSprite;
	private var CompNameTxt:FlxText;
	private var DivisionNameTxt:FlxText;
	private var logoCooldown:Float;

	private var noKeyFlag:Bool = false;

	override public function create():Void
	{

		Reg.controlDef();
		Reg.finalScore = 0;
		title = new FlxText(0, 0);
		title.text = "Ghost and Pumpkins";

		title.size=24;
		title.x = FlxG.width / 2 - title.width / 2;
		title.color = Reg.fontColor;
		title.setBorderStyle(FlxTextBorderStyle.OUTLINE, Reg.fontOutlineColor, 4);
		title.y = FlxG.height/3;

		startMsg = new FlxText(0, 0);
		startMsg.text = "Press Start";
		//startMsg.screenCenter();
		startMsg.y= title.y+title.height + 96;
		startMsg.x = FlxG.width / 2 - startMsg.width / 2;
		startMsg.color = Reg.fontColor;
		startMsg.setBorderStyle(FlxTextBorderStyle.OUTLINE, Reg.fontOutlineColor, 1);
		//FlxG.debugger.visible = true;

		bgColor = Reg.backgroundMenuColor;
		add(title);
		add(startMsg);
		title.visible = false;
		startMsg.visible = false;

		bgColor = Reg.backgroundMenuColor;
		//set_bgColor(Reg.backgroundMenuColor);

		FlxG.camera.fade(Reg.fontColor, 2, true, function () {state = 1; logoCooldown = 2; });

		
		versionMsg = new FlxText();
		versionMsg.text = "Version 0.1";
		versionMsg.color = Reg.fontColor;
		versionMsg.visible = false;
		
		versionMsg.setPosition(FlxG.width / 2 - versionMsg.width / 2, title.y + title.height + 2);
		versionMsg.setBorderStyle(FlxTextBorderStyle.OUTLINE, Reg.fontOutlineColor, 1);
		
		add(versionMsg);
		
		Loadintro();
	}

	override public function update(elapsed:Float):Void
	{
		Reg.UpdateControl();

		super.update(elapsed);
		switch (state)
		{

			case 1:
				intro(elapsed);
			case 2:
				if (Reg.startPress.triggered || Reg.actionPress.triggered)
				{
					FlxG.camera.fade(Reg.fontColor, 2, false, function () {FlxG.switchState(new PlayState()); });
					FlxG.sound.play(AssetPaths.gap_ok__wav);
				}

		}

	}

	public function intro(elapsed:Float)
	{

		if ((logoCooldown<=0 && !noKeyFlag )||Reg.startPress.triggered || Reg.actionPress.triggered)

		{
		
			FlxG.camera.fade(Reg.fontColor, 2, false, function ()
			{
					

				logo.visible = false;
				CompNameTxt.visible = false;
				DivisionNameTxt.visible = false;
				FlxG.camera.fade(Reg.fontColor, 2, true, function ()
				{
					state = 2 ; noKeyFlag = false;

					title.visible = true;

					startMsg.visible = true;
					versionMsg.visible = true;
					FlxG.sound.playMusic(AssetPaths.chord_1__wav, 0.4);
					//FlxG.sound.music.volume = 0.3;
					//FlxG.sound.play(AssetPaths.pitch_lauching__wav);
				});

			});
			

		}
		else
		{
			logoCooldown -= elapsed;

		}
	}

	private function Loadintro()
	{
		logo = new FlxSprite();
		logo.loadGraphic(AssetPaths.CA_Logo_Double_Auntun_pear32__png);
		logo.x = FlxG.width / 2 - logo.width / 2;
		logo.y = FlxG.height / 2 - logo.height ;

		CompNameTxt = new FlxText(0, 0);
		CompNameTxt.text = "CrazyInocent";
		//CompNameTxt.screenCenter();
		CompNameTxt.y= logo.y+logo.height + 2;
		CompNameTxt.x = FlxG.width / 2 - CompNameTxt.width / 2;
		CompNameTxt.color = Reg.fontColor;
		CompNameTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, Reg.fontOutlineColor, 1);

		DivisionNameTxt = new FlxText(0, 0);
		DivisionNameTxt.text = "Games";
		//DivisionNameTxt.screenCenter();
		DivisionNameTxt.y= CompNameTxt.y+CompNameTxt.height + 2;
		DivisionNameTxt.x = FlxG.width / 2 - DivisionNameTxt.width / 2;
		DivisionNameTxt.color = Reg.fontColor;
		DivisionNameTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, Reg.fontOutlineColor, 1);

		add(logo);
		add(CompNameTxt);
		add(DivisionNameTxt);

	}
}