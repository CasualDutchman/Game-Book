package;

import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.util.FlxAxes;
import sys.db.Sqlite;

class HallOfFameState extends FlxState
{
	var mainMenuButton:FlxButton;
	public var deadScoreList:FlxText;
	
	override public function create():Void
	{				
		FlxG.camera.zoom = 2;
		
		mainMenuButton = new FlxButton(0, 540, "Go Back to Main menu", OnMainMenu);
		mainMenuButton.loadGraphic(AssetPaths.button__png, true, 160, 40);
		mainMenuButton.graphicLoaded();
		mainMenuButton.updateHitbox();
		mainMenuButton.label.offset.add(0, -10);
		mainMenuButton.screenCenter(FlxAxes.X);
		add(mainMenuButton);
		
		var sql = Sqlite.open(AssetPaths.database__db);
		var userdata = sql.request("SELECT * FROM User ORDER BY score DESC LIMIT 10");
		
		var playerScoreText:String = "";
		
		for (data in userdata)
		{
			if (data.ID != 0)
			{
				playerScoreText += data.Name + ": " + data.Score + "\n";
			}
		}
		
		deadScoreList = new FlxText(30, 300, 450, "Score:\n" + playerScoreText, 13);
		deadScoreList.screenCenter(FlxAxes.X);
		add(deadScoreList);
		
		super.create();
	}
	
	/**
	 * Callback for the mainMenuButton
	 */
	function OnMainMenu() 
	{
		FlxG.switchState(new MenuState());
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
