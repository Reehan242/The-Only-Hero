extends RemoteTransform2D


# warning-ignore:unused_argument
func _physics_process(delta):
	if DemonLordCondition.cameraboss == true:
		position.y = -120
	else:
		position.y = 0
	
