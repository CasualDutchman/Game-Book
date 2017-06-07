package;

/**
 * ...
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