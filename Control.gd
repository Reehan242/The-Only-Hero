extends Control

onready var lbl_result = $Result
onready var lbl_score = $Score
onready var lbl_highscore = $HighScore

# warning-ignore:unused_argument
func _physics_process(delta):
	if(PlayerStats.condition == 0):
		lbl_result.text = "Kalah..."
	else:
		lbl_result.text = "Menang!"
	if PlayerStats.score < 0:
		lbl_score.text = str("Skor Kamu : ", 0)
	else :
		lbl_score.text = str("Skor Kamu : ", String(PlayerStats.score))
	if(PlayerStats.score > PlayerStats.high_score):
		PlayerStats.high_score = PlayerStats.score
	lbl_highscore.text = str("Skor Tertinggi : ", String(PlayerStats.high_score))
