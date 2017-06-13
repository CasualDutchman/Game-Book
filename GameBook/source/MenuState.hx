package;

import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.util.FlxAxes;
import sys.db.Sqlite;

/**
 * @author Pieter
 */
class MenuState extends FlxState
{		
	var goToStory:Int;
	var goToScene:Int;
	var goToScore:Int;
	
	/**
	 * On creation of the State
	 */
	override public function create():Void
	{				
		//open database
		var sql = Sqlite.open(AssetPaths.database__db);
		var userdata = sql.request("SELECT * FROM User WHERE ID = 0");
		
		//setup Continue data
		for (data in userdata)
		{
			goToScene = data.Scene;
			goToStory = data.Story;
			goToScore = data.Score;
		}
		
		sql.close();
		
		//Setup ui
		FlxG.camera.zoom = 2;
		
		AddButton(0, 250, "New Game", OnNewButton);
		
		AddButton(0, 300, "Continue", OnContinueButton);
		
		AddButton(0, 350, "Hall of fame", OnHallOfFame);
		
		super.create();
	}
	
	/**
	 * Add a button to the State
	 * @param	_x position X
	 * @param	_y position y
	 * @param	_text display text
	 * @param	_click callback
	 */
	function AddButton(_x:Int, _y:Int, _text:String, _click:Void->Void)
	{
		var _button = new FlxButton(_x, _y, _text, _click);
		_button.loadGraphic(AssetPaths.button__png, true, 160, 40);
		_button.graphicLoaded();
		_button.updateHitbox();
		_button.label.offset.add(0, -10);
		_button.screenCenter(FlxAxes.X);
		add(_button);
	}
	
	/**
	 * Callback for the newGameButton
	 */
	function OnNewButton() 
	{
		FlxG.switchState(new SelectState());
	}
	
	/**
	 * Callback for the continueGameButton
	 */
	function OnContinueButton() 
	{
		//create a state to continue with
		var newPlayState:PlayState = new PlayState();
		newPlayState.storyID = goToStory;
		newPlayState.id = goToScene;
		newPlayState.score = goToScore;
		
		//when the story was finished or when failed
		if (goToScene == -1 || goToStory == -1)
		{
			FlxG.switchState(new SelectState());
		}
		else
		{
			FlxG.switchState(newPlayState);
		}
	}
	
	/**
	 * Callback for the hallOfFameButton
	 */
	function OnHallOfFame() 
	{
		FlxG.switchState(new HallOfFameState());
	}
	
	/**
	 * update every frame
	 * @param	elapsed
	 */
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
