package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import source.Reg;
import flixel.FlxG;
//import flixel.FlxObject;
//import flixel.FlxCamera;
//import flixel.FlxBasic;

//import flixel.input.actions.FlxActionInput.FlxInputDeviceObject;
//import flixel.addons.util.FlxFSM;

class PlayState extends FlxState
{
	private var player:Player;
	private var hud:Hud;
	public var hazards:FlxTypedGroup<Hazard>;
	public var items:FlxGroup;
	public var iso:FlxGroup;
	private var gencooldown:Float = 0;
	private var eCount:Int = 0;
	public var generator:ElementGenerator;
	private var stage:TiledLevel;
	
	private var score:Int;

	override public function create():Void
	{
		super.create();
		
		FlxG.camera.fade(Reg.fontColor, 0.5, true);
		generator = new ElementGenerator(this);
		//stage = new TiledLevel("assets/data/map/" + Reg.CurrentRoom  + ".tmx", this);

		player = new Player(128, 128);
		items = new FlxGroup();
		//hazards = new FlxGroup();
		hazards = new FlxTypedGroup<Hazard>();

		stage = new TiledLevel("assets/data/stages/endless-clear.tmx", this);

		player.world = this;
		player.stage = stage;

		hud = new Hud(player,this);

		//var item:Item = new Item(240, 400);
		//items.add(item);

		//FlxG.camera.follow(player);

		//add(stage.collidableTileLayers[0]);
		//add(stage.foregroundTiles);
		//var spr:FlxSprite = new FlxSprite(400 , 240);

		//FlxG.camera.zoom =2;
		//hud
		add(generator);
		add(generator.GenSpots);
		add(stage.imagesLayer);// = new FlxGroup();
		add(stage.foregroundTiles);// = new FlxGroup();
		add(stage.objectsLayer);// = new FlxGroup();
		add(stage.backgroundLayer);// = new FlxGroup();

		add(player);
		add(player.body);
		add(items);
		add(hazards);
		add(player.bullets);
		
		add(hud);
		bgColor = Reg.backgroundColor;
		gencooldown = 2;
		FlxG.camera.follow(player);
		//FlxG.worldBounds.y = -96;
		score = 0;
		//FlxG.sound.music.loadEmbedded("assets/music/chord-1.wav");
		//FlxG.sound.music.play();
		//
		//FlxG.sound.music.volume = 0.7;
					FlxG.sound.playMusic(AssetPaths.chord_1__wav, 0.7);
	}

	override public function update(elapsed:Float):Void
	{

		//FlxG.collide(player, );
		//FlxG.collide(hazards, stage.foregroundTiles);
		stage.collideWithLevel(player);

		for (h in hazards)
		{
			stage.collideWithLevel(h);
		}
		FlxG.overlap(player, items,pickItem);
		FlxG.overlap(player, hazards, touchHazard);
		FlxG.overlap(hazards,player.bullets, enemyCollideBullet);

		Reg.UpdateControl();

		//if(player.getLifepoints()<=0){
		//FlxG.switchState(new GameOverState());
		//}

		super.update(elapsed);
	}

	
	override public function draw():Void
	{
		super.draw();
		
		//draw correction only consider player and hazards.
		
		//var orderlist:Array<FlxObject> = new Array<FlxObject>();
		//
		//
		//orderlist.push(player);
		//
		//for (e in hazards){
			//var pushed:Bool = false;
			//var pos = 0;
			//for (obj in orderlist){
				//if(obj.y+obj.height < e.y+e.height){
					//pushed = true;
					//orderlist.insert(pos, e);
					//trace("pos" + pos + "ol_:" + orderlist.length);
				//}
				//pos++;
			//}
			//
			//if(!pushed){
				//orderlist.push(e);
				//
					//trace("post push pos" + pos + "ol_:" + orderlist.length);
			//}
		//
		//}
		//
		//for (b in player.bullets){
			//var pushed:Bool = false;
			//var pos = 0;
			//for (obj in orderlist){
				//if(obj.y+obj.height < b.y+b.height){
					//pushed = true;
					//orderlist.insert(pos, b);
				//}
				//pos++;
			//}
			//
			//if(!pushed){
				//orderlist.push(b);
			//}
		//
		//}
		//
		//
		//for (obj in orderlist){
			//if(obj.alive && obj.visible){
				//obj.draw();
			//}
		//}
		//
		
		
		
		
		oldDraw();
		
		
		hud.draw();
	}
	
	public function oldDraw(){
			
		var first:Bool = true;
		var pdraw:Bool = false;
		var wasdraw:Bool = false;
		
		
		
		for (h in hazards)
		{
			pdraw = true;
			if (first)
			{
				first = false;
				if (player.y+player.height<h.y+h.height )
				{
					//pdrawed = true;
					pdraw = false;
				}

			}
			else
			{
				if (player.y+player.height>h.y+h.height )
				{
					//pdrawed = true;
					pdraw = false;
				
				}

			}
			
			
			
			if (player.y+player.height<h.y+h.height && pdraw && !wasdraw){
				wasdraw = true;
				player.draw();
				player.body.draw();
			}
			
			if(h.alive && h.visible && h.getLifepoints()>0){
				h.draw();
			}
			
			
			
		}
		
		//draw enemy ghosts
		for (h in hazards)
		{
			
			if(h.alive && h.getLifepoints()<0){
				h.body.draw();
			}
			
			
			
		}
	}

	public function setPlayerPos(X:Float,Y:Float)
	{
		player.x = X - player.width / 2;
		player.y = Y - player.height / 2;

	}
	
	public function getPlayer():Player{
		return player;
	}
	public function getStrOfScore():String{
		return Std.string(score);
	}
	public function enemyCollideBullet(e:Hazard,b:FlxSprite)
	{
		//e.kill();
		
		e.dmg();
		b.kill();
		score+= 100;
		//generator.eCount -= 1;
		generator.enemydefeated();
	}

	public function GameOver()
	{
		
		Reg.finalScore = score;
		FlxG.switchState(new GameOverState());
	}
	public function pickItem(p:Player,item:Item)
	{
		p.heal();
		item.kill();
	}

	public function touchHazard(p:Player,hazard:Hazard)
	{
		
		
		if(p.getLifepoints()>0){
		score+= 10;
		//hazard.kill();
		hazard.dmg();
		}
		p.dmg(1);
		//eCount -= 1;
		
		
		//generator.eCount -= 1;
	}
}