extends CharacterBody2D
@export var speed : float = 400
const  GRAVITY = 3000
var start_timer = 0
var total_time = 0
var player_moving_direction = 0
var player_direction
var jumping : bool = false
var idle : bool

func _process(delta):
	inputs()
	calculate_jump()
	check_idle()
	
	if !is_on_floor():
		velocity.y += GRAVITY * delta
	
	move_and_slide()



func calculate_jump():
	if is_on_floor():
		
		if Input.is_action_just_pressed("jump"):
			velocity.x = 0 
			start_timer = Time.get_ticks_msec()
			jumping = true
		if Input.is_action_just_released("jump") and start_timer:
			var end_timer = Time.get_ticks_msec()
			total_time = (start_timer - end_timer) 
			var jump_strength = clamp(total_time, -1200, -200)
		
			velocity.y = jump_strength 
			
			if player_moving_direction == 1:
				velocity.x = 400 * 1
			elif player_moving_direction == -1:
				velocity.x = 400 * -1
			else:
				velocity.x = 0
			jumping = false
	

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
		if direction:
			velocity.x = direction * speed
		
		elif is_on_floor():
			velocity.x = 0
		
	# ROTATION
		if direction == 1:
			$Sprite2D.flip_h = false
		if direction == -1:
			$Sprite2D.flip_h = true

	
func check_idle():
	if velocity == Vector2(0,0):
		idle = true
	else:
		idle = false
