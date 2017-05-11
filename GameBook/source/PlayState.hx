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

class PlayState extends FlxState
{
	private var currentScene:Int = 0;
	private var currentStory:Int = 0;
	
	private var _text:FlxText;
	
	override public function create():Void
	{
		var cnx = Sqlite.open(AssetPaths.mybase__db);// "mybase.db");
		
		var rset = cnx.request("SELECT * FROM test");
		
		for ( row in rset ) 
		{
			_text = new FlxText(row.posX, row.posY, 0, row.actualText, 20);
			add(_text);
		}
		
		cnx.close();
		
		super.create();
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
