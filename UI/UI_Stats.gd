extends Control

onready var lbl_lvl = $LVL
onready var lbl_xp = $EXP
onready var spr_xp = $"Exp Bar/spr_Exp"
onready var lbl_def = $Def
onready var lbl_atk = $Atk

func update_xp():
	lbl_lvl.text = str("Level ", String(PlayerStats.level))
	
	var current_xp = str(PlayerStats.xp," / ",PlayerStats.xp_bracket[PlayerStats.level-1])
	lbl_xp.text = current_xp
	
	var level_percent = float(PlayerStats.xp / PlayerStats.xp_bracket[PlayerStats.level-1])
	spr_xp.scale.x = level_percent

func update_stats():
	lbl_def.text = str("Def : ", String(PlayerStats.def*10))
	lbl_atk.text = str("Atk : ", String(PlayerStats.atk*10))
	
func _ready():
	update_xp()
	lbl_def.text = str("Def : ", String(PlayerStats.def*10))
	lbl_atk.text = str("Atk : ", String(PlayerStats.atk*10))
# warning-ignore:return_value_discarded
	PlayerStats.connect("xp_update",self,"update_xp")
# warning-ignore:return_value_discarded
	PlayerStats.connect("levelup",self,"update_stats")
