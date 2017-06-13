package;

import flixel.FlxState;
import neko.Lib;
import sys.db.Sqlite;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.addons.ui.FlxInputText;
import flixel.util.FlxAxes;
import flixel.text.FlxText;

/**
 * @author Pieter
 */
class PlayState extends FlxState
{
	private var currentStory:Int = 0;
	
	private var _exitText:FlxText;

	public var id:Int = 0;
	public var storyID:Int = 0;
	public var score:Int = 0;
	
	public var timer:Float = 0.0;
	public var maxTimer:Float;
	public var timerSprite:FlxSprite;
	public var isTimer:Bool = false;
	public var timerID:Int;
	
	public var image:FlxSprite;
	public var _storyLine:FlxText;
	public var optionLines:Array<FlxText> = new Array<FlxText>();
	
	public var deadInputText:FlxInputText;
	public var deadScoreList:FlxText;
	
	var loader:Loader;
	var currentScene:Scene;
	
	/**
	 * On creation of the State
	 */
	override public function create():Void
	{			
		//Load all Scenes from database
		loader = new Loader(storyID);
		
		//Initialize fields
		SetupScene();
		
		super.create();
		
		//Get data and refresh
		ReloadScene();	
	}
	
	/**
	 * Setups up the major components for the scene
	 */
	function SetupScene()
	{
		timerSprite = new FlxSprite((FlxG.width - 1000) / 2, 550);
		timerSprite.makeGraphic(1000, 10);
		
		image = new FlxSprite(20, 20);
		image.scale.add(5, 5);
		add(image);
		
		_exitText = new FlxText(10, FlxG.height - 20 - 20, "Exit", 20);
		_exitText.alpha = 0.5;
		add(_exitText);
		
		_storyLine = new FlxText(20, 10, 0, "", 20);
		_storyLine.wordWrap = true;
		_storyLine.fieldWidth = FlxG.width - (_storyLine.x * 2);
		_storyLine.autoSize = false;
		_storyLine.alignment = FlxTextAlign.CENTER;
		add(_storyLine);
		
		for (i in 0... 5)
		{
			optionLines.push(new FlxText(20, FlxG.height - 75 - (i * 30), "", 20));
			optionLines[i].fieldWidth = FlxG.width - (_storyLine.x * 2);
			optionLines[i].autoSize = false;
			optionLines[i].alignment = FlxTextAlign.CENTER;
			add(optionLines[i]);
		}
	}
	
	/**
	 * update every frame
	 * @param	elapsed
	 */
	override public function update(elapsed:Float):Void
	{
		//If there is a timer, then update the timer
		if (isTimer)
		{
			timer++;
			
			timerSprite.setGraphicSize(1000 - Std.int((timer / maxTimer) * 1000), 20);
			
			if (timer >= maxTimer)
			{
				id = timerID;
				ResetTimer();
				ReloadScene();
			}
		}
		
		//update optionLines
		for (field in optionLines)
		{
			if(field.overlapsPoint(FlxG.mouse.getScreenPosition()))
			{
				field.color = FlxColor.GRAY;
				
				if (FlxG.mouse.justReleased)
				{
					if (field.ID >= 0) // change id of scene and reload the scene
					{
						id = field.ID;
						ResetTimer();
						
						ReloadScene();
						
						score += 10;
						
						var sql = Sqlite.open(AssetPaths.database__db);
						sql.request("UPDATE User SET Story = " + storyID + ", Scene = " + id + ", Score = " + score + " WHERE ID = 0");
						sql.close();
						
						return;
					}
					else if(field.ID == -1) // when lose
					{
						var _sql = Sqlite.open(AssetPaths.database__db);
						_sql.request("UPDATE User SET Story = " + -1 + ", Scene = " + -1 + ", Score = " + 0 + " WHERE ID = 0");
						_sql.close();
						
						score = 0;
						FlxG.switchState(new MenuState());
						return;
					}
					else if(field.ID == -2 || field.ID == -3) // when win - replay
					{
						var _sql = Sqlite.open(AssetPaths.database__db);
						trace(deadInputText.text);
						_sql.request("INSERT INTO User (Name,Scene,Story,Score) VALUES ('" + deadInputText.text + "'," + id + "," + storyID + "," + score + ")");
						_sql.request("UPDATE User SET Story = " + -1 + ", Scene = " + -1 + ", Score = " + 0 + " WHERE ID = 0");
						_sql.close();
						
						score = 0;
						
						if (field.ID == -2)
						{
							FlxG.switchState(new SelectState());
						}
						else
						{
							FlxG.switchState(new HallOfFameState());
						}
						
						return;
					}
				}
			}
			else
			{
				field.color = FlxColor.WHITE;
			}
		}
		
		//update exitText
		if (_exitText.overlapsPoint(FlxG.mouse.getScreenPosition()))
		{
			_exitText.alpha = 0.3;
			
			if (FlxG.mouse.justReleased)
			{
				var sql = Sqlite.open(AssetPaths.database__db);
				sql.request("UPDATE User SET Story = " + storyID + ", Scene = " + id + ", Score = " + score + " WHERE ID = 0");
				sql.close();
				FlxG.switchState(new MenuState());
			}
		}
		else
		{
			_exitText.alpha = 0.5;
		}
		
		super.update(elapsed);
	}
	
	/**
	 * Reset the timer
	 */
	private function ResetTimer()
	{
		isTimer = false;
		timerSprite.kill();
		timer = 0;
		timerID = 0;
	}
	
	/**
	 * Load a new scene of the story
	 */
	public function ReloadScene()
	{
		//variable that manipulates the Y value of the storyLine after all the options are setup. Dynamic
		var mainStoryY:Float= 0;
		
		//Get the scene from the loader
		currentScene = loader.GetScene(id);	
		
		_storyLine.text = currentScene.storyLine;
		
		//refresh image
		image.kill();
		image.loadGraphic("assets/images/" + currentScene.imagePath + ".png");
		image.reset((FlxG.width / 2) - 60, (FlxG.height / 2) - 34 - 100);
		
		if (currentScene.winLose == 1) // lose/die
		{					
			SetupEnd(-1);
			return;
		}
		
		if (currentScene.winLose == 2) // Win
		{					
			SetupEnd(-2);
			
			deadInputText = new FlxInputText(30, 250, 300, "Enter name", 20);
			deadInputText.screenCenter(FlxAxes.X);
			deadInputText.maxLength = 20;
			deadInputText.focusGained = function(){ deadInputText.text = ""; deadInputText.caretIndex = 0; };
			add(deadInputText);
			
			return;
		}
		
		if (currentScene.hasTimer) // when MaxTimer != 0, make a timer
		{
			isTimer = currentScene.hasTimer;
			maxTimer = currentScene.maxTimer;
			timerID = currentScene.timerDefault;
			
			timerSprite = new FlxSprite((FlxG.width - 1000) / 2, 550);
			timerSprite.makeGraphic(1000, 10);
			add(timerSprite);
		}
		
		for (i in 0...5) // update all questions
		{
			if (currentScene.optionLines[i] != null)
			{
				optionLines[i].text = "- " + currentScene.optionLines[i];
				optionLines[i].ID = currentScene.gotoID[i];
				if(i != 0)
					optionLines[i].y = optionLines[i - 1].y - optionLines[i].height - 5;
				mainStoryY += optionLines[i].height;
			}
			else
			{
				optionLines[i].text = "";
			}
		}
		
		_storyLine.y = FlxG.height - 70 - mainStoryY - _storyLine.height;
	}
	
	/**
	 * Setup scene for winning or losing
	 * @param	_i negative ID handling for exiting
	 */
	function SetupEnd(_i:Int)
	{
		image.kill();
		_exitText.kill();
		
		trace("Set to -1");
		
		for (i in 0...5)
		{
			optionLines[i].text = "";
		}
		
		_storyLine.y = 200;
		
		optionLines[0].text = "- Replay";
		optionLines[0].ID = _i;
		optionLines[0].y = FlxG.height - 130;
		
		if (_i == -2)
		{
			optionLines[1].text = "- Go to Hall of Fame";
			optionLines[1].ID = -3;
			optionLines[1].y = FlxG.height - 100;
		}
	}
}