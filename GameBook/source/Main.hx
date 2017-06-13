package;

import flixel.FlxGame;
import openfl.display.Sprite;

/**
 * @author Pieter
 */
class Main extends Sprite
{
	/**
	 * First function to call
	 */
	public function new()
	{
		super();
		
		//creating the flixel game state
		addChild(new FlxGame(0, 0, MenuState));
	}	
}
