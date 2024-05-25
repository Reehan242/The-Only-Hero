extends Node2D
var createdPackage:PackedScene
var my_scene:Node
const saveFile = "user://SavedPackage.tscn"
var timer_on = true
var check_node3 = get_node_or_null("$DialogLayer2/ShowDialog2")
onready var timer = $Timer
# warning-ignore:unused_argument
func _process(delta):
	if ($DialogLayer/ShowDialog.visible == true):
		$UILayer.visible = false
	else:
		$UILayer.visible = true
		var node_to_delete = get_node_or_null("YSort/Gate")
		if node_to_delete == null:
			pass
		else:
			node_to_delete.queue_free()
			autosave()
	if (timer_on == true):
		timer_on = false
		timer.start(30)
	
	var check_node = get_node_or_null("YSort/DemonLord")
	if check_node != null:
		$DemonLordHp/DL_Hp/hpbar.rect_scale.x = float($YSort/DemonLord.stats.health/$YSort/DemonLord.stats.max_health)
		$DemonLordHp/DL_Hp/DLHpIndicator.text = str($YSort/DemonLord.stats.health*10)
		if DemonLordCondition.attacking == false:
			$YSort/DemonLord/AnimationSprite.visible = true
		else:
			$YSort/DemonLord/AnimationSprite.visible = false
	else:
		pass
	if DemonLordCondition.cameraboss == true:
		
		$Camera2D.zoom = Vector2(2,2)
	else:

		$Camera2D.zoom = Vector2(1.5,1.5)
		
	if(DemonLordCondition.cameraboss == true):
		$DemonLordHp.visible = true
	else:
		$DemonLordHp.visible = false	


	
func _ready():
# warning-ignore:return_value_discarded
	PlayerStats.connect("xp_update",self,"autosave")
# warning-ignore:return_value_discarded
	PlayerStats.connect("no_health",self,"endgame")
# warning-ignore:return_value_discarded
	PlayerStats.connect("condition",self,"endgame")
	if PlayerStats.bossarea == false:
		$BG1.play()
	else:
		$BG3.play()
	$PauseLayer/pause.visible = false
	
func loadgame():
	print("trying to load...")
	PlayerStats.load_game()
	createdPackage = load(saveFile)
	if !createdPackage:
		print("No package to create an instance")
		return

#		if my_scene:
#			my_scene.queue_free()
#		my_scene = createdPackage.instance()
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(createdPackage)
	
func autosave():
	get_tree().paused = false
	print("trying to save...")
	PlayerStats.save_game()
#		createdPackage = ScenePacker.create_package(self)
	createdPackage = PackedScene.new()
# warning-ignore:return_value_discarded
	createdPackage.pack(get_tree().get_current_scene())
	if !createdPackage:
		print("No package to save")
		return

	var error: = ResourceSaver.save(saveFile, createdPackage)
	if error != OK:
		push_error("An error occurred while saving the scene to disk.")
		
func _on_Timer_timeout():
	autosave()
	timer_on = true
func endgame():
	if PlayerStats.health > 0 :
		PlayerStats.score += PlayerStats.health*100
	$BG1.stop()
	$BG3.stop()
	if PlayerStats.condition == 0 :
		$BG2.play(0)
	else:
		$BG4.play(0)
	var save_file = File.new()
	var dir = Directory.new()
	if save_file.file_exists("user://SavedPackage.tscn"):
		dir.remove("user://SavedPackage.tscn")
	if save_file.file_exists("user://save_game.save"):
		dir.remove("user://save_game.save")
	timer_on = false
	timer.stop()
	$YSort/Player.queue_free()
	$PauseLayer.queue_free()
	$ResultLayer/Control.visible = true

func _on_Main_Menu_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Menu.tscn")
	
	

func _on_rslt_Main_menu_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Menu.tscn")
	if $YSort.is_connected("child_exiting_tree",self,"_on_YSort_child_exiting_tree"):
		$YSort.disconnect("child_exiting_tree",self,"_on_YSort_child_exiting_tree")
	var save_file = File.new()
	var dir = Directory.new()
	if save_file.file_exists("user://SavedPackage.tscn"):
		dir.remove("user://SavedPackage.tscn")
	if save_file.file_exists("user://save_game.save"):
		dir.remove("user://save_game.save")


func showdialog2():
	pass
# warning-ignore:unused_argument
func _on_Angel2_area_entered(area):
	$DialogLayer2/ShowDialog2.visible = true

# warning-ignore:unused_argument
func _on_BossArea_area_entered(area):
	$BossArea.queue_free()
	PlayerStats.bossarea = true
	$BG1.stop()
	$BG3.play(0)
	


func _on_ShowDialog2_tree_exited():
	$YSort/Angel2.queue_free()

func _on_YSort_child_exiting_tree(node):
#	print(str(node))
	if('Bat' or 'Slime' in str(node)):
		print("save via exit tree")
		autosave()
