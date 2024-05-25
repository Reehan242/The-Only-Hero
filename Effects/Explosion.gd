extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	connect("animation_finished",self,"_on_AnimatedSprite_animation_finished")
	frame = 0
	play("Animate")

func _on_AnimatedSprite_animation_finished():
	queue_free()
