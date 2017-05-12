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
	
	private var currentNode:Node;
	
	override public function create():Void
	{
		currentNode = new Node(0, 0);
		add(currentNode);
		add(currentNode._storyLine);
		for (i in 0...5)
		{
			add(currentNode.optionLines[i]);
		}
		
		super.create();
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
