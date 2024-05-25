extends Control

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		DemonLordCondition.stream_paused()
		var new_pause_state = not get_tree().paused 
		get_tree().paused = new_pause_state
# warning-ignore:standalone_expression
		DemonLordCondition.PAUSE_MODE_INHERIT
		visible = new_pause_state
		$Panduan.visible = false


func _on_Main_Menu_pressed():
	get_tree().paused = false

func _on_Exit_pressed():
	get_tree().quit()


func _on_Button_pressed():
	$Panduan.visible = true
