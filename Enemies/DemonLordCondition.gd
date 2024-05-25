extends Node2D

var attacking = false
var laser = false
var cameraboss = false
var dialog2 = false

func _ready():
	attacking = false
	laser = false
	dialog2 = false

# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("Toggle Fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
# warning-ignore:standalone_expression
	Input.MOUSE_MODE_VISIBLE
	
func play_laser():
	$AudioStreamPlayer.play(0)
func stop_laser():
	$AudioStreamPlayer.stop()

func _on_AudioStreamPlayer_finished():
	stop_laser()

func reset():
	attacking = false
	laser = false
	cameraboss = false
	dialog2 = false

func stream_paused():
	var test = $AudioStreamPlayer.stream_paused
	$AudioStreamPlayer.stream_paused = !test
