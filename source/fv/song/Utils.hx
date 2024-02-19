package fv.song;

import fv.song.Chart;

class Utils {
	public static function saveChart(ChartData:ChartJson, SongDifficulty:String = ''):Void {
		if (!Chart.isValidBPM(ChartData)) {
			trace('You CANNOT save a song with less than ${Chart.MinBPM} BPM.');
			return;
		}
		sys.io.File.saveContent(
			Paths.json('${Paths.formatToSongPath(ChartData.Meta.Song)}/${Paths.formatToSongPath(ChartData.Meta.Song)}${(SongDifficulty != null && SongDifficulty != '' && SongDifficulty.toLowerCase() != 'normal') ? '-$SongDifficulty' : ''}'),
			haxe.Json.stringify(ChartData, '\t')
		);
		trace('Chart "${Paths.formatToSongPath(ChartData.Meta.Song)}${(SongDifficulty != null && SongDifficulty != '' && SongDifficulty.toLowerCase() != 'normal') ? '-$SongDifficulty' : ''}" sucessfully saved!');
	}
}

class EventUtil {
	public static inline function isOfValidType(Event:ChartEvent):Bool { return Event != null && (Event.Type == ChartEventType.TEMPO || Event.Type == ChartEventType.GAMEPLAY || Event.Type == ChartEventType.SCRIPTED); }
}