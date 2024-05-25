extends Control

var nama = ["???","Angel", "Hero","Angel", "Hero", "Angel"]
var dialog = ["Ughh.., tempat apa ini!? \nKenapa aku tiba tiba ada disini?"
			, "Selamat datang, Hero.\nTempat ini adalah Green Hollow.\nSaat ini Green Hollow sedang terinfeksi dan dipenuhi monster akibat kehadiran Demon Lord.\nAku adalah Angel.\nAkulah yang telah memanggilmu kedunia ini.\nKami sangat membutuhkan bantuan mu Hero."
			, "Green Hollow? Demon Lord? \nAku kurang begitu mengerti tapi sepertinya aku dapat membantu.\nJadi apa yang harus kulakukan?"
			, "Hanya kamulah yang memiliki kekuatan untuk mengalahkan Demon Lord. \nTolong kalahkan dia, dan semua terror di Green Hollow akan menghilang."
			, "Baiklah, jika itu bisa menyelamatkan dunia ini, aku akan melakukannya."
			, "Terima kasih Hero, berjuanglah!"]
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
		visible = false

