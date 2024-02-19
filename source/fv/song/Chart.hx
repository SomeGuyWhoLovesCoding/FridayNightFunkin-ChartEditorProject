package fv.song;

import haxe.Json;
//import fv.song.Utils;

enum abstract FocusSection(String) from String to String {
	var GF:String = 'gf';
	var P3:String = 'p3';
	var P4:String = 'p4';
	var DAD:String = 'dad';
	var BF:String = 'bf';
	var CUSTOM:String = '';
}

enum abstract ChartEventType(String) from String to String {
	var TEMPO:String = 'tempo';
	var GAMEPLAY:String = 'gameplay';
	var SCRIPTED:String = 'scripted';
}

typedef ChartTimeSignature = {
	Beats:Int,
	Steps:Int,
	?Bars:Int
}

typedef Section = {
	SectionNotes:Array<ChartNote>,
	FocusSection:FocusSection
}

typedef ChartNote = {
	StrumTime:Float,
	NoteData:Int,
	SustainLength:Float,
	Type:String,
	MustPress:Bool
}

typedef ChartEvent = {
	Type:ChartEventType,
	Name:String,
	Value1:String,
	?Value2:String,
	?Value3:String,
	Offset:Float
}

typedef ChartJson = {
	Meta:{
		Song:String,
		BPM:Float,
		Speed:Float,
		TimeSignature:ChartTimeSignature, // 3 Dimensional
		NeedsVoices:Bool,
	},
	Gameplay:{
		Sections:Array<Section>,
		Events:Array<ChartEvent>,
		Dad:String,
		Boyfriend:String,
		Girlfriend:String,
		?Player3:String,
		?Player4:String,
		Stage:String,
		?NoteSkin:String
	}
}

class Chart {
	// Variables used for the JSON
	public var Song:String = 'test';
	public var NeedsVoices:Bool = true;
	public var BPM:Float = 100.0;
	public var Speed:Float = 1.0;
	public var TimeSignature:ChartTimeSignature = {Beats: 4, Steps: 4, Bars: 1};
	public var Sections:Array<Section> = [];
	public var Events:Array<ChartEvent> = [];
	public var Dad:String = 'bf-pixel';
	public var Boyfriend:String = '';
	public var Girlfriend:String = 'gf';
	public var Player3:String = '';
	public var Player4:String = '';
	public var Stage:String = 'stage';
	public var NoteSkin:String = 'Default';

	private final Data:ChartJson;

	// Used for checks.
	public static var MinBPM:Float = 10.0;

	public function new(SongName:String = 'test', SongDifficulty:String = ''):Void {
		try {
			Data = Json.parse(sys.io.File.getContent(Paths.json('$SongName/$SongName${(SongDifficulty != null && SongDifficulty != '' && SongDifficulty.toLowerCase() != 'normal') ? '-$SongDifficulty' : ''}')));
		} catch(e:Dynamic) {
			trace('Chart not found ($e): Using dummy chart instead');
			Data = Chart.generateDummy();
		}
		setData(Data);
		//trace(Data);
	}

	public static function generateDummy():ChartJson {
		return {
			Meta: {
				Song: 'Test',
				BPM: 150.0,
				Speed: 1.0,
				TimeSignature: {
					Beats: 4,
					Steps: 4,
					Bars: 1
				},
				NeedsVoices: true
			},
			Gameplay: {
				Sections: [],
				Events: [],
				Dad: 'bf',
				Boyfriend: 'bf',
				Girlfriend: 'gf',
				Player3: '',
				Player4: '',
				Stage: 'stage'
			}
		}
	}

	public static inline function isValidBPM(ChartData:ChartJson):Bool { return ChartData.Meta.BPM >= MinBPM; } // Prevents songs from saving under the minimum bpm. That's obvious.

	public static inline function exists(SongName:String, SongDifficulty:String):Bool {
		return sys.FileSystem.exists(
			Paths.json('$SongName/$SongName${(SongDifficulty != null && SongDifficulty != '' && SongDifficulty.toLowerCase() != 'normal') ? '-$SongDifficulty' : ''}')
		);
	}

	public function setData(ChartData:ChartJson):Void {
		Song = ChartData.Meta.Song;
		BPM = ChartData.Meta.BPM;
		TimeSignature = ChartData.Meta.TimeSignature;
		NeedsVoices = ChartData.Meta.NeedsVoices;
		Sections = ChartData.Gameplay.Sections;
		if (Sections.length != 0) {
			// Fix sections
			var i:Int = 0; while (i < Sections.length) {
				var j:Int = 0; while (j < Sections[i].SectionNotes.length) {
					if (Sections[i].SectionNotes[j].NoteData >= 4 || Sections[i].SectionNotes[j].NoteData <= -1) {
						Sections[i].SectionNotes[j].NoteData = Sections[i].SectionNotes[j].NoteData % 4;
					}
					if (Sections[i].SectionNotes[j].Type == null || Sections[i].SectionNotes[j].Type == '') {
						Sections[i].SectionNotes[j].Type = 'Default';
						//trace(Sections[i].SectionNotes[j].Type);
					}
					j++;
				}
				i++;
			}
		}
		Events = ChartData.Gameplay.Events;
		if (Events.length != 0) {
			// Fix events
			var i:Int = 0; while (i < Events.length) {
				if (!EventUtil.isOfValidType(Events[i])) {
					trace('Event ${i+1} with type "${Events[i].Type}" removed, not valid.');
					Events.remove(Events[i]); // Don't trigger events that have an invalid type
				}
				i++;
			}
		}
		Dad = ChartData.Gameplay.Dad;
		Boyfriend = ChartData.Gameplay.Boyfriend;
		Girlfriend = ChartData.Gameplay.Girlfriend;
		Player3 = ChartData.Gameplay.Player3;
		Player4 = ChartData.Gameplay.Player4;
		Stage = ChartData.Gameplay.Stage;
		if (ChartData.Gameplay.NoteSkin != null && ChartData.Gameplay.NoteSkin != '') NoteSkin = ChartData.Gameplay.NoteSkin;
	}

	public function getData():ChartJson {
		return {
			Meta: {
				Song: Song,
				BPM: BPM,
				Speed: Speed,
				TimeSignature: TimeSignature,
				NeedsVoices: NeedsVoices
			},
			Gameplay: {
				Sections: Sections,
				Events: Events,
				Dad: Dad,
				Boyfriend: Boyfriend,
				Girlfriend: Girlfriend,
				Player3: Player3,
				Player4: Player4,
				Stage: Stage,
				NoteSkin: NoteSkin
			}
		}
	}

	public function generateTimeSignature(Beats:Int, Steps:Int, ?Bars:Int = 1):ChartTimeSignature {
		return {Beats: Beats, Steps: Steps, Bars: Bars};
	}
}