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
	FALL
}


func _process(delta):
	inputs()
	calculate_jump()
	check_idle()
	#print(jumping)
	if !is_on_floor():
		calculateFall(delta)
		
	if is_on_floor() and animationState == AnimationState.FALL :
	#	
		var collision = get_slide_collision(0)
		
		
		animationState = AnimationState.NEUTRAL
		kevin_animation.play("Idle")
	
	if is_on_floor() and animationState == AnimationState.CHARGE and getJumpStrength() == -1200 :
		animationState = AnimationState.CHARGEREADY
		kevin_animation.play("ChargeMax")
	
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
			animationState = AnimationState.CHARGE
			kevin_animation.play("Charge")
		if Input.is_action_just_released("jump") and start_timer and jumping == true:
			velocity.y = getJumpStrength()
			velocity.x = speed * player_moving_direction
			start_timer = null
			jumping = false
			kevin_animation.play("Midair")

func calculateFall(delta) :
	var gravity = GRAVITY if velocity.y < 0 else GRAVITY_FLOAT
	velocity.y += gravity * delta
	jumping = false
	if animationState != AnimationState.FALL and velocity.y > 0 :
		animationState = AnimationState.FALL
		kevin_animation.play("Falling")

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
	# MOVEMENT
		if ice_floor:
			if direction:
				
				velocity.x = lerpf(velocity.x, direction * speed, .1)
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
		#print("Tilemap")
		var collided_tiles_coords = current_tilemap.get_coords_for_body_rid(body_rid)
		var tile_data = current_tilemap.get_cell_tile_data(collided_tiles_coords)
		var terrain_mask = tile_data.get_custom_data_by_layer_id(0)
		#print(terrain_mask)
		if terrain_mask == 2:
			ice_floor = true
		else:
			ice_floor = false
	
	
	#var collided_tiles_coords = current_tilemap.get_coords_for_body_rid(body_rid)
