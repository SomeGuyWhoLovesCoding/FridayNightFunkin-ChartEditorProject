package;

using StringTools;

class Paths
{
	inline static public function json(key:String, ?library:String) {
		return 'assets/data/$key.json';
	}
    
    inline static public function formatToSongPath(path:String) {
		var invalidChars = ~/[~&\\;:<>#]/;
		var hideChars = ~/[.,'"%?!]/;

		var path = invalidChars.split(path.replace(' ', '-')).join("-");
		return hideChars.split(path).join('').toLowerCase();
	}
}