package;

import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.util.FlxAxes;

class MenuState extends FlxState
{
	var newGameButton:FlxButton;
	var continueGameButton:FlxButton;
	
	override public function create():Void
	{				
		FlxG.camera.zoom = 2;
		
		newGameButton = new FlxButton(0, 150, "New Game", OnNewButton);
		newGameButton.screenCenter(FlxAxes.X);
		add(newGameButton);
		
		continueGameButton = new FlxButton(0, 175, "Continue", OnContinueButton);
		continueGameButton.screenCenter(FlxAxes.X);
		add(continueGameButton);
		
		super.create();
	}
	
	function OnNewButton() 
	{
		FlxG.switchState(new PlayState());
	}
	
	function OnContinueButton() 
	{
		FlxG.switchState(new PlayState());
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
