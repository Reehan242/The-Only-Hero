extends Control
var createdPackage:PackedScene
onready var btn_continue = $VBoxContainer/Continue_Game
var save_file = File.new()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if save_file.file_exists("user://SavedPackage.tscn") and save_file.file_exists("user://save_game.save"):
		btn_continue.disabled = false
	else:
		btn_continue.disabled = true
	$AudioStreamPlayer.play(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Start_pressed():
	var dir = Directory.new()
	if save_file.file_exists("user://SavedPackage.tscn"):
		dir.remove("user://SavedPackage.tscn")
	if save_file.file_exists("user://save_game.save"):
		dir.remove("user://save_game.save")
	PlayerStats.reset()
	DemonLordCondition.reset()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://world.tscn")


func _on_Continue_Game_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("user://SavedPackage.tscn")
	PlayerStats.load_game()
	DemonLordCondition.attacking = false
	DemonLordCondition.laser = false
	


func _on_Exit_pressed():
	get_tree().quit() # Replace with function body.


func _on_Help_pressed():
	$Panduan.visible = true
