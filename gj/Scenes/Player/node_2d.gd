extends CharacterBody2D
@export var jumpspeed : float = -600
@export var speed : float = 400
const  GRAVITY = 3000
var start_timer 
var total_time
var player_direction
var collision_info
var animationState = AnimationState.NEUTRAL

enum AnimationState {
	NEUTRAL,
	BOUNCE
} 


func _process(delta):
	inputs()
	calculate_jump()
	#print(rotation_degrees)
	if !is_on_floor():
		velocity.y += GRAVITY * delta
	
	var tempVel = velocity
	move_and_slide()
	
	calculateBounce(tempVel)

func calculate_jump():
	if is_on_floor():
		
		if Input.is_action_just_pressed("jump"):
			start_timer = Time.get_ticks_msec()
		
		if Input.is_action_just_released("jump"):
			var end_timer = Time.get_ticks_msec()
		
			total_time = start_timer - end_timer
			var jump_strength = clamp(total_time, -3000, -200)
		
			velocity.y = jump_strength
		
			if player_direction == 1:
				velocity.x = 400 * 1
			elif player_direction == -1:
				velocity.x = 400 * -1
			else:
				velocity.x = 0
		
	
	#var jump_strength = clamp(total_time, 200, 2000)
	
	#velocity = jump_strength

func calculateBounce(tempVelocity : Vector2):
	if get_slide_collision_count() > 0 && !is_on_floor():
		print(tempVelocity)
		var collision = get_slide_collision(0)
		if collision != null:
			velocity = tempVelocity.bounce(collision.get_normal())
			velocity.x *= 0.8
			player_direction *= -1
			rotateSprite(player_direction)
			#$Sprite2D.rotate(20*player_direction)

func _unhandled_input(event):
	pass
	#inputs(event)
	
func inputs():
	
	var direction = Input.get_axis("move_left","move_right")
	if direction != 0:
		player_direction = direction
	# MOVEMENT
	if direction:
		velocity.x = direction * speed
		
	elif is_on_floor():
		velocity.x = 0
		
	rotateSprite(direction)	
	
func rotateSprite(direction):
	if direction == 1:
		$Sprite2D.flip_h = false
	if direction == -1:
		$Sprite2D.flip_h = true
