extends Area2D
const explode = preload("res://Effects/Explosion.tscn")
var damage = 5
var type = "unit"
var direct = rand_range(-30,30)
func _physics_process(delta):
	position.y += 100*delta
	position.x += direct*delta
	
func _ready():
	randomize()
# warning-ignore:return_value_discarded
	$DLAnimation.connect("animation_finished",self,"_on_DLAnimation_animation_finished")
	$DLAnimation.frame = 0
	$DLAnimation.play("Animate")
	
# warning-ignore:unused_argument
func _on_DLBomb_area_entered(area):
	var explosion = explode.instance()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	queue_free()


func _on_DLAnimation_animation_finished():
	var explosion = explode.instance()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	queue_free()
