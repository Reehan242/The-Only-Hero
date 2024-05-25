extends KinematicBody2D

export var MAX_SPEED = 80
export var ACCELERATION = 500
export var ROLL_SPEED = 120
export var FRICTION = 500
onready var world = get_node("/root/World")
enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats
var dot = false
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var SwordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtboxes


func _ready():
	randomize()
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	SwordHitbox.knockback_vector = roll_vector

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
	
	
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		SwordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else : 
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move()
	

	if Input.is_action_just_pressed("roll"):
		state = ROLL

	if Input.is_action_just_pressed("attack"):
		state = ATTACK

# warning-ignore:unused_argument
func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

# warning-ignore:unused_argument
func attack_state(delta):
	velocity = velocity / 2
	animationState.travel("Attack")

func move():
	velocity = move_and_slide(velocity)

func roll_animation_finished():
	state = MOVE
	velocity = velocity / 2

func attack_animation_finished():
	state = MOVE


func _on_Hurtboxes_area_entered(area):
	world.autosave()
	if(area.type == "unit"):
		if (area.damage - (stats.def/2) >= 0.1):
			stats.health -= (area.damage-(stats.def/2))
		else:
			stats.health -= 0.1
		hurtbox.start_invincibility(0.8)
		hurtbox.create_hit_effect()
		print("Player health = ",stats.health , " \nPlayer def = ", stats.def , " \ndmg reduction = ", stats.def/2)
	elif(area.type == "dot"):
		hurtbox.start_invincibility(0.4)
		stats.health -= area.damage
		print("Player health = ",stats.health)
