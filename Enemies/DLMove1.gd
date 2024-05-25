extends AnimatedSprite

const BULLET = preload("res://Effects/DLBomb.tscn")

func _ready():
# warning-ignore:return_value_discarded
	connect("animation_finished",self,"_on_AnimatedSprite_animation_finished")
	frame = 0
	play("default")
func _on_AnimatedSprite_animation_finished():
	var bullet =  BULLET.instance()
	var main = get_tree().current_scene
	main.add_child(bullet)
	bullet.global_position = $Position2D.global_position
	DemonLordCondition.attacking = false
	queue_free()
	

func _on_Timer_timeout():
	queue_free()
	
# warning-ignore:unused_argument
func _physics_process(delta):
	if PlayerStats.condition == 1:
		queue_free()
