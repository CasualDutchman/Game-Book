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
class HallOfFameState extends FlxState
{
	var mainMenuButton:FlxButton;
	public var deadScoreList:FlxText;
	
	/**
	 * On creation of the State
	 */
	override public function create():Void
	{				
		//open database
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
		
		sql.close();
		
		//setup ui
		FlxG.camera.zoom = 2;
		
		AddButton(0, 540, "Go Back to Main menu", OnMainMenu);
		
		deadScoreList = new FlxText(30, 300, 450, "Score:\n" + playerScoreText, 13);
		deadScoreList.screenCenter(FlxAxes.X);
		add(deadScoreList);
		
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
