extends AnimatedSprite

onready var BULLET = preload("res://Effects/DLLaser.tscn")


func _ready():
# warning-ignore:return_value_discarded
	z_as_relative = true
	connect("animation_finished",self,"_on_AnimatedSprite_animation_finished")
	frame = 0
	play("default")
	$Timer.start(0.1)
	DemonLordCondition.laser = false
	
func _on_AnimatedSprite_animation_finished():
	DemonLordCondition.laser = true
	DemonLordCondition.attacking = false
	DemonLordCondition.play_laser()
	queue_free()
	

func _on_Timer_timeout():
	var i = 0
	while(i < 25):
		i += 1
		var bullet =  BULLET.instance()
		var main = get_tree().current_scene
		main.add_child(bullet)
		bullet.global_position = $Position2D.global_position
	$Timer.stop()

# warning-ignore:unused_argument
func _physics_process(delta):
	if PlayerStats.condition == 1:
		queue_free()
