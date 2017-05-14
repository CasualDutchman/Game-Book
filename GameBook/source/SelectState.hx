package;

import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.util.FlxAxes;
import sys.db.Sqlite;
import flixel.util.FlxColor;

class SelectState extends FlxState
{
	var newPlayState:PlayState;
	
	var button:FlxButton;
	
	public var _storyLine:FlxText;
	public var optionLines:Array<FlxText> = new Array<FlxText>();
	
	override public function create():Void
	{				
		var sql = Sqlite.open(AssetPaths.database__db);
		
		var rset = sql.request("SELECT * FROM Stories");
		
		_storyLine = new FlxText(10, FlxG.height - 200, 0, "What timeline shall we pick?", 20);
		_storyLine.wordWrap = true;
		_storyLine.fieldWidth = FlxG.width - (_storyLine.x * 2);
		_storyLine.autoSize = false;
		_storyLine.alignment = FlxTextAlign.CENTER;
		add(_storyLine);
		
		for ( row in rset ) 
		{
			var newText:FlxText = new FlxText(10, _storyLine.y + 30 + (row.ID * 30), row.Name + "", 20);
			newText.fieldWidth = FlxG.width - (_storyLine.x * 2);
			newText.autoSize = false;
			newText.alignment = FlxTextAlign.CENTER;
			newText.ID = row.GoToId;
			optionLines.push(newText);
			add(newText);
		}
		
		sql.close();
		
		super.create();
	}
	
	override public function update(elapsed:Float):Void
	{
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
					newPlayState = new PlayState();
					newPlayState.storyID = field.ID;
					FlxG.switchState(newPlayState);
				}
			}
		}
		super.update(elapsed);
	}
}
