package;

/**
 * @author Pieter
 */
class Scene 
{

	public var storyLine:String;
	
	public var optionLines:Array<String> = [];
	public var gotoID:Array<Int> = [];
	
	public var imagePath:String;
	
	public var hasTimer:Bool = false;
	public var maxTimer:Int = 0;
	public var timerDefault:Int = 0;
	
	//when 1 Lose || 2 Win
	public var winLose:Int = 0;
	
	/**
	 * This class holds all the information for a scene of a story
	 * @param	story String with story line
	 * @param	lines Strings with option text
	 * @param	goto Ints with new scene IDs when clicked
	 * @param	image String path of the image
	 * @param	_hasTimer does the scene have a timer
	 * @param	_maxTimer max duration of timer
	 * @param	_timerDefault default scene ID when timer runs out
	 * @param	_winLose 0 = normal | 1 = lose | 2 = win
	 */
	public function new(story:String, lines:Array<String>, goto:Array<Int>, image:String = "0-0", _hasTimer:Bool = false, _maxTimer:Int = 0, _timerDefault:Int = 0, _winLose:Int = 0) 
	{
		storyLine = story;
		optionLines = lines;
		gotoID = goto;
		imagePath = image;
		hasTimer = _hasTimer;
		maxTimer = _maxTimer;
		timerDefault = _timerDefault;
		winLose = _winLose;
	}
	
}