extends Control

var nama = ["Hero", "Angel","Hero", "Angel", "Hero","Angel"]
var dialog = ["Uggh bagaimana kamu bisa ada disini!?\nBukannya tadi..."
			, "Itu tidak penting...\nBersiaplah Hero!\nDi depan sana kamu akan bertemu Demon Lord"
			, "Ah disana dia rupanya! \nAku tinggal mengalahkannya saja kan?"
			, "Benar sekali!\nDengan begitu semua pengaruh Demon Lord akan menghilang dari dunia ini..."
			, "Tenang saja, aku akan menyelamatkan Green Hollow!"
			, "Sekali lagi terima kasih Hero, berhati-hatilah!"]
var i  = 0
onready var lbl_name = $lbl_Name
onready var lbl_dialog = $lbl_dialog
onready var spr_hero = $Hero
onready var spr_angel = $Angel
func _ready():
	lbl_name.text = nama[i]
	lbl_dialog.text = dialog[i]
	spr_hero.self_modulate = Color(1.0,1.0,1.0,1.0)
	spr_angel.self_modulate= Color(0,0,0,1)
# warning-ignore:unused_argument
func _process(delta):
	if(visible == true):
		$next_dialog.grab_focus()
func _on_next_dialog_pressed():
	if(i < nama.size()-1):
		if((i%2)==0):
			spr_hero.self_modulate = Color(0,0,0,1)
			spr_angel.self_modulate= Color(1.0,1.0,1.0,1.0)
		else:
			spr_hero.self_modulate = Color(1.0,1.0,1.0,1.0)
			spr_angel.self_modulate= Color(0,0,0,1)
		i = i+1
		lbl_name.text = nama[i]
		lbl_dialog.text = dialog[i]
	else:
		queue_free()
		
