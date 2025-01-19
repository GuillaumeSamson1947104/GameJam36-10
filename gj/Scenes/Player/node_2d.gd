extends CharacterBody2D
@onready var kevin_animation = $KevinAnimation
@export var speed : float = 400
const  GRAVITY = 3000
const GRAVITY_FLOAT = 800
const maxStrength = -1200
var start_timer = 0
var total_time = 0
var player_moving_direction = 0
var player_direction

var jumping : bool = false
var idle : bool

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
	
	if !is_on_floor():
		calculateFall(delta)
		
	if is_on_floor() and animationState == AnimationState.FALL :
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
			velocity.x = 0 
			start_timer = Time.get_ticks_msec()
			jumping = true
			animationState = AnimationState.CHARGE
			kevin_animation.play("Charge")
			
		if Input.is_action_just_released("jump") and start_timer:
			#Resetting Timer
			velocity.y = getJumpStrength()
			velocity.x = speed * player_moving_direction
			start_timer = null
			jumping = false
			kevin_animation.play("Midair")

func calculateFall(delta) :
	var gravity = GRAVITY if velocity.y < 0 else GRAVITY_FLOAT
	velocity.y += gravity * delta
	if animationState != AnimationState.FALL and velocity.y > 0 :
		animationState = AnimationState.FALL
		kevin_animation.play("Falling")

func getJumpStrength() :
	if(!start_timer) :
		return 0
	var end_timer = Time.get_ticks_msec()
	total_time = start_timer - end_timer 
	print(clamp(total_time, -1200, -200))
	return clamp(total_time, -1200, -200)

func calculateBounce(tempVelocity : Vector2):
	if get_slide_collision_count() > 0 && is_on_wall_only():
		print(tempVelocity)
		var collision = get_slide_collision(0)
		if collision != null:
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
		if direction:
			velocity.x = direction * speed
		
		elif is_on_floor():
			velocity.x = 0

		rotateSprite(direction)
	
func check_idle():
	if velocity == Vector2(0,0):
		idle = true
	else:
		idle = false
	
func rotateSprite(direction):
	if direction == 1:
		$AnimatedSprite.flip_h = false
	if direction == -1:
		$AnimatedSprite.flip_h = true
