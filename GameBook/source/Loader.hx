package;

import sys.db.Sqlite;

/**
 * ...
 * @author Pieter
 */
class Loader 
{

	public var Scenes:Array<Scene> = [];
	
	public function new(storyID:Int) 
	{
		LoadDataBase(storyID);
	}
	
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
	
	public function GetScene(index:Int):Scene
	{
		return Scenes[index];
	}
	
}