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
		
		newGameButton = new FlxButton(0, 250, "New Game", OnNewButton);
		newGameButton.loadGraphic(AssetPaths.button__png, true, 160, 40);
		newGameButton.graphicLoaded();
		newGameButton.updateHitbox();
		newGameButton.label.offset.add(0, -10);
		newGameButton.screenCenter(FlxAxes.X);
		add(newGameButton);
		
		continueGameButton = new FlxButton(0, 300, "Continue", OnContinueButton);
		continueGameButton.loadGraphic(AssetPaths.button__png, true, 160, 40);
		continueGameButton.graphicLoaded();
		continueGameButton.updateHitbox();
		continueGameButton.label.offset.add(0, -10);
		continueGameButton.screenCenter(FlxAxes.X);
		add(continueGameButton);
		
		super.create();
	}
	
	function OnNewButton() 
	{
		FlxG.switchState(new SelectState());
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
