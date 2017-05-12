/**
 * I will use one database slot to hold names of stories
 * Those will open a new database slot, based on that story name.
 * There databases contain the story and choices.
 * 
 * at the end it will be saved to a user database
 */

package;

import flixel.FlxState;
import sys.db.Sqlite;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxG;

class PlayState extends FlxState
{
	private var currentScene:Int = 0;
	private var currentStory:Int = 0;
	
	private var _text:FlxText;
		
	public var id:Int = 0;
	public var storyID:Int = 0;
	
	public var image:FlxSprite;
	public var _storyLine:FlxText;
	public var optionLines:Array<FlxText> = new Array<FlxText>();
	
	override public function create():Void
	{
		_storyLine = new FlxText(10, 10, 0, "", 20);
		for (i in 0... 5)
		{
			optionLines.push(new FlxText(10, 30 + (i * 20), "", 20));
		}
		
		add(_storyLine);
		for (i in 0...5)
		{
			add(optionLines[i]);
		}
		
		super.create();
		
		LoadNode();
	}
	
	override public function update(elapsed:Float):Void
	{
		if (FlxG.mouse.justReleased)
		{
			for (field in optionLines)
			{
				if(field.overlapsPoint(FlxG.mouse.getScreenPosition()))
				{
					id = field.ID;
					LoadNode();
				}
			}
		}
		super.update(elapsed);
	}
	
	public function LoadNode()
	{
		var sql = Sqlite.open(AssetPaths.database__db);// "mybase.db");
		
		var rset = sql.request("SELECT * FROM " + sql.quote("story" + storyID + ""));
		
		for ( row in rset ) 
		{
			if (row.NodeID == id)
			{
				_storyLine.text = row.StoryLine;
				
				if (Std.string(row.Line1).length > 0)
				{
					optionLines[0].text = row.Line1;
					optionLines[0].ID = row.GoToID1;
				}
				
				if (Std.string(row.Line2).length > 0)
				{
					optionLines[1].text = row.Line2;
					optionLines[1].ID = row.GoToID2;
				}
				
				if (Std.string(row.Line3).length > 0)
				{
					optionLines[2].text = row.Line3;
					optionLines[2].ID = row.GoToID3;
				}
				
				if (Std.string(row.Line4).length > 0)
				{
					optionLines[3].text = row.Line4;
					optionLines[3].ID = row.GoToID4;
				}
				
				if (Std.string(row.Line5).length > 0)
				{
					optionLines[4].text = row.Line5;
					optionLines[4].ID = row.GoToID5;
				}
				break;
			}
		}
		
		sql.close();
	}
}
