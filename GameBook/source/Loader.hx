package;

import sys.db.Sqlite;

/**
 * @author Pieter
 */
class Loader 
{
	//array of all the scenes in the story
	public var Scenes:Array<Scene> = [];
	
	/**
	 * This file will contain all the Scenes for a story specified by the parameter. This class will read all the scenes of that story from the database
	 * @param	storyID ID of the story
	 */
	public function new(storyID:Int) 
	{
		LoadDataBase(storyID);
	}
	
	/**
	 * Load all scenes from the database and store in the array
	 * @param	id ID of story
	 */
	function LoadDataBase(id:Int)
	{
		var sql = Sqlite.open(AssetPaths.database__db);
		var rset = sql.request("SELECT * FROM " + sql.quote("story" + id + "") + " ORDER BY NodeID ASC");
		
		for (row in rset)
		{
			Scenes.push(new Scene(row.StoryLine, [row.Line1, row.Line2, row.Line3, row.Line4, row.Line5], [row.GoToID1, row.GoToID2, row.GoToID3, row.GoToID4, row.GoToID5], row.Image, row.MaxTimer > 0, row.MaxTimer, row.TimerDefault, row.Dead));
		}
		
		sql.close();
	}
	
	/**
	 * Get the scene in the loader
	 * @param	index ID of scene
	 * @return Scene from story loader
	 */
	public function GetScene(index:Int):Scene
	{
		return Scenes[index];
	}
	
}