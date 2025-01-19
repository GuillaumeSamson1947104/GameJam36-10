extends CharacterBody2D
@onready var world_scene = preload("res://Scenes/World/world.tscn").instantiate()
@onready var kevin_animation = $KevinAnimation
#@onready var tilemap : TileMap = $TileMapLayer
@export var speed : float = 400

const  GRAVITY = 3000
const GRAVITY_FLOAT = 800
const maxStrength = -1200
var start_timer = 0
var total_time = 0
var player_moving_direction = 0
var player_direction
var current_tilemap 
var tile_mask
var jumping : bool = false
var idle : bool
var ice_floor = false
var collision_info
var animationState = AnimationState.NEUTRAL
enum AnimationState {
	NEUTRAL,
	CHARGE,
	CHARGEREADY,
	JUMP,
	FALL,
	WALK
}

const soundWalk = preload("res://assets/Sounds/ESM_GF_fx_dirt_one_shots_footstep_sand_boots_dry_interior_67.wav")
const soundFall = preload("res://assets/Sounds/WindGusts_BW.59811.wav")
const soundFlap = preload("res://assets/Sounds/MonsterWingsFlap_SFXB.1452.wav")
const soundFast = preload("res://assets/Sounds/SPLC-0595_FX_Oneshot_Wind_Storm_Strong.wav")


func _process(delta):
	inputs()
	calculate_jump()
	check_idle()
	if !is_on_floor():
		calculateFall(delta)
		
	if is_on_floor() and (animationState == AnimationState.FALL) :
	#	
		var collision = get_slide_collision(0)
		
		
		setAnimationState(AnimationState.NEUTRAL)
	
	if is_on_floor() and animationState == AnimationState.CHARGE and getJumpStrength() == -1200 :
		setAnimationState(AnimationState.CHARGEREADY)
	
	var tempVel = velocity
	move_and_slide()
	
	calculateBounce(tempVel)

func calculate_jump():
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			if ice_floor:
				velocity.x = lerpf(velocity.x , 0 ,.3)
			else:
				velocity.x = 0 
			start_timer = Time.get_ticks_msec()
			jumping = true
			setAnimationState(AnimationState.CHARGE)
		if Input.is_action_just_released("jump") and start_timer and jumping == true:
			velocity.y = getJumpStrength()
			velocity.x = speed * player_moving_direction
			start_timer = null
			jumping = false
			setAnimationState(AnimationState.JUMP)

func calculateFall(delta) :
	var gravity = GRAVITY if velocity.y < 0 else GRAVITY_FLOAT
	velocity.y += gravity * delta
	jumping = false
	if animationState != AnimationState.FALL and velocity.y > 0 :
		setAnimationState(AnimationState.FALL)

func getJumpStrength() :
	if(!start_timer) :
		return 0
	var end_timer = Time.get_ticks_msec()
	total_time = start_timer - end_timer 
	return clamp(total_time, -1200, -200)

func calculateBounce(tempVelocity : Vector2):
	if get_slide_collision_count() > 0 && is_on_wall_only():
		var collision = get_slide_collision(0)
		if(collision.get_angle() < 1):
			return
		velocity = tempVelocity.bounce(collision.get_normal())
		velocity.x *= 0.8
		player_moving_direction *= -1
		rotateSprite(player_moving_direction)
		#$Sprite2D.rotate(20*player_direction)

func _unhandled_input(event):
	pass
	
	
func inputs():
	if is_on_floor() and jumping == false:
	
		var direction = Input.get_axis("move_left","move_right")
		player_direction = direction
		if direction != 0:
			player_moving_direction = direction
			start_timer = null
			if(animationState != AnimationState.WALK) :
				setAnimationState(AnimationState.WALK)
		elif (animationState == AnimationState.WALK) :
			setAnimationState(AnimationState.NEUTRAL)
	# MOVEMENT
		if ice_floor:
			if direction:
				
				velocity.x = lerpf(velocity.x, direction *speed, .1)
			else:
				#velocity.x = 0
				velocity.x = lerpf(velocity.x , 0 , 0.03)
			#rotateSprite(direction)
		else:
			if direction:
				velocity.x = direction * speed
			else:
				velocity.x = 0
		rotateSprite(direction)
func check_idle():
	if velocity == Vector2(0,0):
		idle = true
	else:
		idle = false
	
func rotateSprite(direction):
	if direction == 1:
		$KevinAnimation.flip_h = false
	if direction == -1:
		$KevinAnimation.flip_h = true


func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is TileMapLayer:
		current_tilemap = body
		var collided_tiles_coords = current_tilemap.get_coords_for_body_rid(body_rid)
		var tile_data = current_tilemap.get_cell_tile_data(collided_tiles_coords)
		var terrain_mask = tile_data.get_custom_data_by_layer_id(0)
		if terrain_mask == 2:
			ice_floor = true
		else:
			ice_floor = false
	
func setAnimationState(state: AnimationState) :
	print(state)
	match state:
		AnimationState.NEUTRAL:
			animationState = AnimationState.NEUTRAL
			kevin_animation.play("Idle")
			$PlayerSounds.stream = null
		AnimationState.CHARGE:
			animationState = AnimationState.CHARGE
			kevin_animation.play("Charge")
			$PlayerSounds.stream = null
		AnimationState.CHARGEREADY:
			animationState = AnimationState.CHARGEREADY
			kevin_animation.play("ChargeMax")
			$PlayerSounds.stream = null
		AnimationState.JUMP:
			animationState = AnimationState.JUMP
			kevin_animation.play("Midair")
			$PlayerSounds.stream = soundFlap
			$PlayerSounds.play()
		AnimationState.FALL:
			animationState = AnimationState.FALL
			$PlayerSounds.stream = soundFall
			kevin_animation.play("Falling")
			$PlayerSounds.play()
		AnimationState.WALK:
			animationState = AnimationState.WALK
			$PlayerSounds.stream = soundWalk
			kevin_animation.play("Idle")
			$PlayerSounds.play()


func _on_player_sounds_finished() -> void:
	$PlayerSounds.play()
