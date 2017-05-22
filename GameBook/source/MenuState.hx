package;

import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.util.FlxAxes;
import sys.db.Sqlite;

class MenuState extends FlxState
{
	var newGameButton:FlxButton;
	var continueGameButton:FlxButton;
	var hallOfFameButton:FlxButton;
	
	private var sql:sys.db.Connection;
	
	var goToStory:Int;
	var goToScene:Int;
	var goToScore:Int;
	
	override public function create():Void
	{				
		sql = Sqlite.open(AssetPaths.database__db);
		
		var userdata = sql.request("SELECT * FROM User");
		
		for (data in userdata)
		{
			if (data.ID == 0)
			{
				goToScene = data.Scene;
				goToStory = data.Story;
				goToScore = data.Score;
			}
		}
		
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
		
		hallOfFameButton = new FlxButton(0, 350, "Hall of fame", OnHallOfFame);
		hallOfFameButton.loadGraphic(AssetPaths.button__png, true, 160, 40);
		hallOfFameButton.graphicLoaded();
		hallOfFameButton.updateHitbox();
		hallOfFameButton.label.offset.add(0, -10);
		hallOfFameButton.screenCenter(FlxAxes.X);
		add(hallOfFameButton);
		
		super.create();
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
		var newPlayState:PlayState = new PlayState();
		newPlayState.storyID = goToStory;
		newPlayState.id = goToScene;
		newPlayState.score = goToScore;
		
		if (goToScene == -1 || goToStory == -1)
		{
			FlxG.switchState(new SelectState());
		}
		else
		{
			FlxG.switchState(newPlayState);
		}
		sql.close();
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
