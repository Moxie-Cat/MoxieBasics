extends Node

var current_music:EventAsset
var _current_music_instance:EventInstance

var _music_bus:Bus
var _sfx_bus:Bus

var music_volume:float:get = _get_music_volume, set = _set_music_volume
var sfx_volume:float:get = _get_sfx_volume, set = _set_sfx_volume

const _music_bus_path = "bus:/Music"
const _sfx_bus_path = "bus:/SFX"

# --- INITIALIZATION -- 

func _ready():
	# Initialize the busses
	_music_bus = FMODStudioModule.get_studio_system().get_bus(_music_bus_path)
	_sfx_bus = FMODStudioModule.get_studio_system().get_bus(_sfx_bus_path)

# --- VOLUME MANAGEMENT ---

func _get_music_volume():
	return _music_bus.get_volume()["volume"]

func _set_music_volume(value:float):
	if _music_bus:
		_music_bus.set_volume(value)
	else:
		printerr("No audio bus found at %s" % _music_bus_path)

func _get_sfx_volume():
	return _sfx_bus.get_volume()["volume"]

func _set_sfx_volume(value:float):
	if _sfx_bus:
		_sfx_bus.set_volume(value)
	else:
		printerr("No audio bus found at %s" % _music_bus_path)

# --- UTILITY ---

# Plays music. If not supplied with a new event, will resume previous music.
func play_music(music:EventAsset = null):
	if music != null:
		await set_music(music)
	_current_music_instance.start()

# Changes the value of current_music and creates a new _current_music_instance.
func set_music(new_event:EventAsset):
	# Fail if new_event is the same as the current_music event.
	if new_event == current_music:
		return
	
	# Throw warning if not music
	if !new_event.path.begins_with("event:/MUS/"):
		print(
			"Tried to set music to a non-music event - %s"
			% new_event.path
		)
	
	# If music is currently playing, make sure to stop it.
	if (_current_music_instance &&
	(_current_music_instance.get_playback_state()
		== FMODStudioModule.FMOD_STUDIO_PLAYBACK_PLAYING
	)):
		await stop_music()
	
	# Finally, perform the actual setup.
	current_music = new_event
	if _current_music_instance:
		_current_music_instance.release()
	_current_music_instance = FMODRuntime.create_instance(new_event)

# Stops the currently-playing music.
func stop_music():
	_current_music_instance.stop(FMODStudioModule.FMOD_STUDIO_STOP_ALLOWFADEOUT)
	# Idle for a bit while it fades out.
	while (_current_music_instance.get_playback_state()
		== FMODStudioModule.FMOD_STUDIO_PLAYBACK_STOPPING
	):
		await get_tree().process_frame

# Plays a 2D sound effect. PLEASE USE StudioEventEmitters INSTEAD!!
func play_sfx(event:EventAsset):
	FMODRuntime.play_one_shot(event)
	pass
