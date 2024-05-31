package source;
import flixel.input.actions.FlxAction.FlxActionDigital;
import flixel.input.actions.FlxActionManager;
import flixel.input.actions.FlxActionSet;
import flixel.input.gamepad.FlxGamepadInputID;

import flixel.graphics.frames.FlxAtlasFrames;

/**
 * ...
 * @author Santiago Arrieta
 */
class Reg 
{

	
	public static var finalScore:Int = 0;
	public static var manager:FlxActionManager;

	public static var controlSet:FlxActionSet=null;
	// preessed left
	public static var left:FlxActionDigital;
	/** preessed justleft*/
	public static var leftPress:FlxActionDigital;
	public static var leftReleased:FlxActionDigital;

	public static var right:FlxActionDigital;
	public static var rightPress:FlxActionDigital;
	public static var rightReleased:FlxActionDigital;

	public static var up:FlxActionDigital;

	public static var upPress:FlxActionDigital;
	/**just Released Up*/
	public static var upReleased:FlxActionDigital;
	/**preessed Down*/
	public static var down:FlxActionDigital;
	/**just preessed Down*/
	public static var downPress:FlxActionDigital;
	/**just Released Down*/
	public static var downReleased:FlxActionDigital;
	


	/**jump(for default z) btn JustPressed*/
	public static var jump:FlxActionDigital;
	
	//jump(for default z) btn justPressed*/
	public static var jumpPress:FlxActionDigital;
	
	
	/*back(for default x btn Pressed*/
	public static var back:FlxActionDigital;
	public static var backPress:FlxActionDigital;
	
	//Action(for default c) btn Pressed/
	public static var action:FlxActionDigital;

	//Action(for default c) btn Just Pressed/
	public static var actionPress:FlxActionDigital;

	//Start btn Pressed
	public static var start:FlxActionDigital;

	//Start btn Just Pressed
	public static var startPress:FlxActionDigital;
	
	
	//Select(for default space) btn Just Pressed/
	public static var select:FlxActionDigital;
	public static var selectPress:FlxActionDigital;
	
	//Select(for default space) btn Just Pressed/
	public static var itemBtn:FlxActionDigital;
	public static var itemBtnPress:FlxActionDigital;
	
	//Select(for default space) btn Just Pressed/
	public static var form:FlxActionDigital;
	public static var formPress:FlxActionDigital;
	
	public static function controlDef():Void
	{
		back = new FlxActionDigital();
		back.addKey(X, PRESSED);

		backPress = new FlxActionDigital();
		backPress.addKey(X, JUST_PRESSED);

		jump = new FlxActionDigital();
		jump.addKey(Z, PRESSED);
		
			//gameInput
		//jump.addGamepad(FlxGamepadInputID.X,PRESSED);

		jumpPress = new FlxActionDigital();
		jumpPress.addKey(Z, JUST_PRESSED);
		//gameInput
		jumpPress.addGamepad(FlxGamepadInputID.X, JUST_PRESSED);
		
		action = new FlxActionDigital();
		action.addKey(C, PRESSED);

		actionPress = new FlxActionDigital();
		actionPress.addKey(C, JUST_PRESSED);

		//ARROWS

		left  = new FlxActionDigital();
		left.addKey(LEFT, PRESSED);

		leftPress  = new FlxActionDigital();
		leftPress.addKey(LEFT, JUST_PRESSED);

		leftReleased = new FlxActionDigital();
		leftReleased.addKey(LEFT, JUST_RELEASED);
		
		right  = new FlxActionDigital();
		right.addKey(RIGHT, PRESSED);

		rightPress  = new FlxActionDigital();
		rightPress.addKey(RIGHT, JUST_PRESSED);

		rightReleased  = new FlxActionDigital();
		rightReleased.addKey(RIGHT, JUST_RELEASED);
		
		
		up  = new FlxActionDigital();
		up.addKey(UP, PRESSED);

		upPress  = new FlxActionDigital();
		upPress.addKey(UP, JUST_PRESSED);

		upReleased = new FlxActionDigital();
		upReleased.addKey(UP, JUST_RELEASED);
		
		down  = new FlxActionDigital();
		down.addKey(DOWN, PRESSED);

		downPress  = new FlxActionDigital();
		downPress.addKey(DOWN, JUST_PRESSED);

		downReleased  = new FlxActionDigital();
		downReleased.addKey(DOWN, JUST_RELEASED);
		
		
		
		select = new FlxActionDigital();
		select.addKey(SPACE, PRESSED);
		
		selectPress  = new FlxActionDigital();
		selectPress.addKey(SPACE, JUST_PRESSED);

		
		start  = new FlxActionDigital();
		start.addKey(ENTER, PRESSED);
		
		startPress  = new FlxActionDigital();
		startPress.addKey(ENTER, JUST_PRESSED);
		
		itemBtn  = new FlxActionDigital();
		itemBtn.addKey(A, JUST_PRESSED);
		
		itemBtnPress  = new FlxActionDigital();
		itemBtnPress.addKey(A, JUST_PRESSED);
		
			
		form  = new FlxActionDigital();
		form.addKey(S, JUST_PRESSED);
		
		formPress  = new FlxActionDigital();
		formPress.addKey(S, JUST_PRESSED);
		
		controlSet = new FlxActionSet("current",
		[
			back, backPress,
			jump, jumpPress,
			action, actionPress,
			left, leftPress,leftReleased,
			right, rightPress,rightReleased,
			up, upPress,upReleased,
			down, downPress, downReleased,
			select, selectPress, start, startPress,
			itemBtn,itemBtnPress,form,formPress
			
		]
									 );

		//manager = new FlxActionManager();
//
		//manager.addAction(actionPress);
		//manager.addAction(jump);
		//manager.addAction(jumpPress);

		//FlxG.inputs.add(manager);

	}

	
	//upodate controls call before cUpdate in the state or su
	public static function UpdateControl():Void
	{
		controlSet.update();

	}
	
	
	public static var fontColor:Int = 0xFFE36956;
	public static var fontOutlineColor:Int = 0xffFFFFEB;
	public static var backgroundColor:Int = 0xff473B78;
	public static var backgroundMenuColor:Int = 0xff5E315B;
}