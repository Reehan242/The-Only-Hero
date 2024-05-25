extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const LaserEffect = preload("res://Enemies/DLMove2.tscn")
const BombEffect = preload("res://Enemies/DLMove1.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 25
export var FRICTION = 200
export var WANDER_TARGET_RANGE = 1 
export var dmg = 2


enum{
	IDLE,
	WANDER,
	CHASE
}
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var collision = Vector2.ZERO
var state = IDLE
var collide = false
var poison = true

onready var sprite = $AnimationSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtboxes
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var obstacleDetect = $ObstacleDetection
onready var DL_pos = self.position
onready var timer = $Timer

func _ready():
	randomize()
	state = pick_random_state([IDLE,WANDER])

func _physics_process(delta):
	collision = move_and_collide(velocity * delta)
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION*delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
#			velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
			seek_player()
			poison = true
			timer.stop()
			#check_obstacle()
			if wanderController.get_time_left() == 0:
				update_wander()
		WANDER:
			seek_player()
#			check_obstacle()
			poison = true
			timer.stop()
#			if wanderController.get_time_left() == 0:
#				state = pick_random_state([IDLE,WANDER])
#				wanderController.start_wander_timer(rand_range(1,3))
#			accelerator_towards_point(wanderController.target_position, delta)
#
#			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
#				update_wander()
		CHASE:
#			check_obstacle()
			if(poison == true):
				poison = false
				timer.start(3.5)
			var player = playerDetectionZone.player
			if player != null:
				DemonLordCondition.cameraboss = true
#				accelerator_towards_point(player.global_position, delta)
			else:
				DemonLordCondition.cameraboss = false
				state = IDLE

	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity =  move_and_slide(velocity)

	
#func check_obstacle():
#	if obstacleDetect.is_teleport() == true:
#		self.position = DL_pos
#		obstacleDetect.teleport = false

#func accelerator_towards_point(point, delta):
#	var direction = global_position.direction_to(point)
#	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
#	sprite.flip_h = velocity.x < 0
	
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func update_wander():
	state = pick_random_state([IDLE,WANDER])
	wanderController.start_wander_timer(rand_range(1,3))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func create_poison():
	poison = true
	print("demon lord is attacking")
	var atk_choose = randi() % 2
	var effect = null
	if atk_choose == 0 :
		effect = LaserEffect.instance()
	else:
		effect = BombEffect.instance()
	var main = get_tree().current_scene
	DemonLordCondition.attacking = true
	main.add_child(effect)
	effect.global_position = $Position2D.global_position 
	
# warning-ignore:unused_argument
func _on_Hurtboxes_area_entered(area):
	stats.health -= PlayerStats.atk
	print(stats.health)
#	knockback = area.knockback_vector * 5
	hurtbox.create_hit_effect()


func _on_Stats_no_health():
	PlayerStats.condition_change(1)
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	


func _on_Timer_timeout():
	create_poison()
