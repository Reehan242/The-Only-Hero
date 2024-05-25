extends Node

export var max_health = 1.0 setget set_max_health
var health = max_health setget set_health
var defaultxp = 0.0
var defaulthp = 5
var defaultdef = 0.0
var defaultlvl = 1
var defaultatk = 1.0
var high_score = 0
var level = 1

var bossarea = false
#var def_bracket = [0, 1, 2, 3, 4, 5 ]
var def = 0.0
var atk = 1.0
var xp = 0.0
var score = 0
var xp_bracket = [250, 400, 600, 1000, 1300 , 1500, 1500]
var condition = 0
signal no_health
signal health_changed(value)
signal max_health_changed(value)
signal xp_update
signal levelup
signal condition

func addexp(xp_points):
	if level < xp_bracket.size()  :                   	#Check if we are at level cap
		xp += xp_points  
		score += xp_points*10                               	#Add experience points
		while (xp >= xp_bracket[level-1]):  				#while we are above the exp cap
			xp -= xp_bracket[level-1]      					#take away experience = to the cap
			level += 1	
			def += 1.0   
			atk += 0.5  
			emit_signal("levelup")                           	#increase level
		if level >= xp_bracket.size() :              	#if we reach level cap
			xp = 0.0	                                	#change experience to 0
	else:
		xp = 0.0	         
	emit_signal("xp_update")  

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)
	
func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")
		condition = 0

func _ready():
	self.health = max_health
	
	var save_file = File.new()
	if save_file.file_exists("user://saved_highscore.save"):
		save_file.open("user://saved_highscore.save", File.READ)
		var data_highscore = save_file.get_var()
		high_score = data_highscore["high_score"]
		save_file.close()
	
func save_game():
	var save_file = File.new()
	save_file.open("user://save_game.save",File.WRITE)
	var data={
		"level":level,
		"def":def,
		"xp":xp,
		"hp":health,
		"atk" : atk,
		"score" : score,
		"bossarea" : bossarea
	}
	
	save_file.store_var(data)
	save_file.close()
	save_file.open("user://saved_highscore.save",File.WRITE)
	var data_highscore ={
		"high_score": high_score
	}
	save_file.store_var(data_highscore)
	save_file.close()



func load_game():
	var save_file = File.new()
	if !save_file.file_exists("user://save_game.save"):
		return
	save_file.open("user://save_game.save",File.READ)
	var data = save_file.get_var()
	level = data["level"]
	xp = data["xp"]
	def = data["def"]
	health = data["hp"]
	atk = data["atk"]
	score = data["score"]
	bossarea = data["bossarea"]
	save_file.close()
	save_file.open("user://saved_highscore.save",File.READ)
	var data_highscore = save_file.get_var()
	high_score = data_highscore["high_score"]
	save_file.close()

func reset():
	condition = 0
	def = defaultdef
	health = defaulthp
	level = defaultlvl
	xp = defaultxp
	atk = defaultatk
	score = 0
	bossarea = false
	
func condition_change(cond):
	condition = cond
	score += 15000
	emit_signal("condition")
