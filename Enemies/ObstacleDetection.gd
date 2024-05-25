extends Area2D
onready var timer = $Timer
var teleport = false


# warning-ignore:unused_argument
func _on_ObstacleDetection_body_entered(body):
	timer.start(15)
	#print("obs detected")

# warning-ignore:unused_argument
func _on_ObstacleDetection_body_exited(body):
	timer.stop()
	#print("obs not detected")


func _on_Timer_timeout():
	teleport = true

func is_teleport():
	return teleport
