package;

import flixel.FlxSprite;
import flixel.text.FlxText;
import sys.db.Sqlite;
import flixel.FlxG;

class Node extends FlxSprite
{
	public var id:Int = 0;
	public var storyID:Int = 0;
	
	public var image:FlxSprite;
	public var _storyLine:FlxText;
	public var optionLines:Array<FlxText> = new Array<FlxText>();
	
	public function new(_id:Int, _sto:Int) 
	{
		super();
		id = _id;
		storyID = _sto;
		
		_storyLine = new FlxText(10, 10, 0, "", 20);
		for (i in 0... 5)
		{
			optionLines.push(new FlxText(10, 30 + (i * 20), "", 20));
		}
		
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