extends Node

# sounds resources
const sounds_path = "res://Sounds/"
var sounds_file_names = [
	"Bullet",
	"Click",
	"EnemyDie",
	"Explosion",
	"Hurt",
	"Jump",
	"Pause",
	"Powerup",
	"Step",
	"Unpause",
]
var streams = {}

# players
onready var sound_players = get_children()

func _ready():
	load_sounds()
	
func load_sounds():
	for file_name in sounds_file_names:
		streams[file_name] = load(sounds_path + file_name + ".wav")

func play(stream_name: String, volume_db: float = 0, pitch_scale: float = 1):
	if not streams.has(stream_name):
		push_error("play: unknown stream name: %s" % stream_name)
		return
	
	for player in sound_players:
		if not player.playing:
			player.stream = streams[stream_name]
			player.volume_db = volume_db
			player.pitch_scale = pitch_scale
			player.play()
			return
			
	push_warning("play: too many sounds playing at the same time, ignored: %s" % stream_name)
