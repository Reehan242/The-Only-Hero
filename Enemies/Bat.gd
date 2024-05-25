extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")


export var ACCELERATION = 300
export var MAX_SPEED = 25
export var FRICTION = 200
export var WANDER_TARGET_RANGE = 1 
export var dmg = 1

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


onready var sprite = $AnimationSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtboxes
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var obstacleDetect = $ObstacleDetection
onready var bat_pos = self.position
onready var player = PlayerStats

func _ready():
	state = pick_random_state([IDLE,WANDER])

func _physics_process(delta):
	collision = move_and_collide(velocity * delta)
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION*delta)
	knockback = move_and_slide(knockback)
	$EnemyHPbar/Hpbar.rect_scale.x = float(stats.health/stats.max_health)
	$EnemyHPbar/Hp.text = str(stats.health*10)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
			seek_player()
			#check_obstacle()
			if wanderController.get_time_left() == 0:
				update_wander()
		WANDER:
			seek_player()
			check_obstacle()
			if wanderController.get_time_left() == 0:
				state = pick_random_state([IDLE,WANDER])
				wanderController.start_wander_timer(rand_range(1,3))
			accelerator_towards_point(wanderController.target_position, delta)
				
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
		CHASE:
			check_obstacle()
# warning-ignore:shadowed_variable
			var player = playerDetectionZone.player
			if player != null:
				accelerator_towards_point(player.global_position, delta)
			else:
				state = IDLE
	


	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity =  move_and_slide(velocity)

	
func check_obstacle():
	if obstacleDetect.is_teleport() == true:
		self.position = bat_pos
		obstacleDetect.teleport = false

func accelerator_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0
	
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func update_wander():
	state = pick_random_state([IDLE,WANDER])
	wanderController.start_wander_timer(rand_range(1,3))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Hurtboxes_area_entered(area):
	stats.health -= PlayerStats.atk
	print(stats.health)
	knockback = area.knockback_vector * 150
	hurtbox.create_hit_effect()


func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	player.addexp(50)
