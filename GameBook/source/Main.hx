package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		//creating the flixel game state
		addChild(new FlxGame(0, 0, MenuState));
	}	
}
