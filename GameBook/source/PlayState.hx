/**
 * I will use one database slot to hold names of stories
 * Those will open a new database slot, based on that story name.
 * There databases contain the story and choices.
 * 
 * at the end it will be saved to a user database
 */

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

class PlayState extends FlxState
{
	private var currentScene:Int = 0;
	private var currentStory:Int = 0;
	
	private var _exitText:FlxText;
	
	private var sql:sys.db.Connection;
	var rset:sys.db.ResultSet;
	
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
	
	override public function create():Void
	{		
		sql = Sqlite.open(AssetPaths.database__db);
		
		rset = sql.request("SELECT * FROM " + sql.quote("story" + storyID + ""));
		
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
		
		super.create();
		
		ReloadScene();
	}
	
	/**
	 * update every frame
	 * @param	elapsed
	 */
	override public function update(elapsed:Float):Void
	{
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
		
		for (field in optionLines)
		{
			if(field.overlapsPoint(FlxG.mouse.getScreenPosition()))
			{
				field.color = FlxColor.GRAY;
			}
			else
			{
				field.color = FlxColor.WHITE;
			}
		}
		
		if (FlxG.mouse.justReleased)
		{
			for (field in optionLines)
			{
				if(field.overlapsPoint(FlxG.mouse.getScreenPosition()))
				{
					if (field.ID >= 0)
					{
						id = field.ID;
						ResetTimer();
						ReloadScene();
						
						score += 10;
						
						sql.request("UPDATE User SET Story = " + storyID + ", Scene = " + id + ", Score = " + score + " WHERE ID = 0");
						
						break;
					}
					else if(field.ID == -1) // when lose
					{
						sql.request("UPDATE User SET Story = " + -1 + ", Scene = " + -1 + ", Score = " + 0 + " WHERE ID = 0");
						sql.close();
						
						score = 0;
						FlxG.switchState(new MenuState());
					}
					else if(field.ID == -2) // when win
					{
						sql.request("INSERT INTO User (Name,Scene,Story,Score) VALUES ('" + deadInputText.text + "'," + id + "," + storyID + "," + score + ")");
						sql.request("UPDATE User SET Story = " + -1 + ", Scene = " + -1 + ", Score = " + 0 + " WHERE ID = 0");
						sql.close();
						
						score = 0;
						FlxG.switchState(new HallOfFameState());
					}
				}
			}
		}
		
		if (_exitText.overlapsPoint(FlxG.mouse.getScreenPosition()))
		{
			_exitText.alpha = 0.3;
			
			if (FlxG.mouse.justReleased)
			{
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
	 * Load a new set of the story
	 */
	public function ReloadScene()
	{
		image.kill();
		
		var mainStoryY:Float= 0;
		
		for ( row in rset ) 
		{
			if (row.NodeID == id)
			{
				_storyLine.text = row.StoryLine;
				
				image.loadGraphic("assets/images/" + row.Image + ".png");
				image.reset((FlxG.width / 2) - 60, (FlxG.height / 2) - 34 - 100);
				
				if (row.Dead == 1) // lose/die
				{					
					image.kill();
					_exitText.kill();
					
					_storyLine.y = 200;
					optionLines[0].text = "- Go to main menu";
					optionLines[0].ID = -1;
					optionLines[0].y = FlxG.height - 100;
					
					for (i in 0...4)
					{
						optionLines[i + 1].text = "";
					}
					break;
				}
				
				if (row.Dead == 2) // Win
				{					
					image.kill();
					_exitText.kill();
					
					_storyLine.y = 200;
					optionLines[0].text = "- Go to main menu";
					optionLines[0].ID = -2;
					optionLines[0].y = FlxG.height - 100;
					
					for (i in 0...4)
					{
						optionLines[i + 1].text = "";
					}
					
					deadInputText = new FlxInputText(30, 250, 300, "Enter name", 20);
					deadInputText.screenCenter(FlxAxes.X);
					deadInputText.maxLength = 20;
					deadInputText.focusGained = function(){ deadInputText.text = ""; deadInputText.caretIndex = 0; };
					add(deadInputText);
					break;
				}
				
				if (row.MaxTimer != 0)
				{
					Lib.println("GOTIMER");
					isTimer = true;
					maxTimer = row.MaxTimer;
					timerID = row.TimerDefault;
					add(timerSprite);
				}
				
				if (row.Line1 != null)
				{
					optionLines[0].text = "- " + row.Line1;
					optionLines[0].ID = row.GoToID1;
					mainStoryY += optionLines[0].height;
				}
				
				if (row.Line2 != null)
				{
					optionLines[1].text = "- " + row.Line2;
					optionLines[1].ID = row.GoToID2;
					optionLines[1].y = optionLines[0].y - optionLines[1].height - 5;
					mainStoryY += optionLines[1].height;
				}
				else
				{
					optionLines[1].text = "";
				}
				
				if (row.Line3 != null)
				{
					optionLines[2].text = "- " + row.Line3;
					optionLines[2].ID = row.GoToID3;
					optionLines[2].y = optionLines[1].y - optionLines[2].height - 5;
					mainStoryY += optionLines[2].height;
				}
				else
				{
					optionLines[2].text = "";
				}
				
				if (row.Line4 != null)
				{
					optionLines[3].text = "- " + row.Line4;
					optionLines[3].ID = row.GoToID4;
					optionLines[3].y = optionLines[2].y - optionLines[3].height - 5;
					mainStoryY += optionLines[3].height;
				}
				else
				{
					optionLines[3].text = "";
				}
				
				if (row.Line5 != null)
				{
					optionLines[4].text = "- " + row.Line5;
					optionLines[4].ID = row.GoToID5;
					optionLines[4].y = optionLines[3].y - optionLines[4].height - 5;
					mainStoryY += optionLines[4].height;
				}
				else
				{
					optionLines[4].text = "";
				}
				
				_storyLine.y = FlxG.height - 70 - mainStoryY - _storyLine.height;
				
				break;
			}
		}
	}
}