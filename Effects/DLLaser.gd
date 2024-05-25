extends Area2D
var damage = 1
var type = "unit"
var direct = rand_range(-160,160)

	
func _ready():
	randomize()
# warning-ignore:return_value_discarded
	$DLAnimation.connect("animation_finished",self,"_on_DLAnimation_animation_finished")
	rotation_degrees = direct
	$DLAnimation.frame = 0
	$DLAnimation.playing = false
	$DLAnimation.self_modulate = Color(1.0,1.0,1.0,0.2)
#	monitoring = false
	$CollisionShape2D.disabled = true

# warning-ignore:unused_argument
func _physics_process(delta):
	if DemonLordCondition.laser == true:
#		DemonLordCondition.laser = false
		$DLAnimation.playing = true
		$DLAnimation.self_modulate = Color(1.0,1.0,1.0,0.8)
#		monitoring = true
		$CollisionShape2D.disabled = false
	

# warning-ignore:unused_argument
func _on_DLLaser_area_entered(area):
	queue_free()

func _on_DLAnimation_animation_finished():
	DemonLordCondition.stop_laser()
	queue_free()
