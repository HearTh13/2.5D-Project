extends CharacterBody3D

var coin = 0
const SPEED = 2.5
const JUMP_VELOCITY = 4.5
@onready var image = $Sprite3D
@onready var player_anim = $PlayerAnimation

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("action") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var move = "move_forward"
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if Input.is_action_pressed("move_forward"):
			move = "move_forward"
		if Input.is_action_pressed("move_backward"):
			move = "move_backward"
		if Input.is_action_pressed("move_left"):
			move = "move_left"
		if Input.is_action_pressed("move_right"):
			move = "move_right"
		if Input.is_action_pressed("move_right") && Input.is_action_pressed("move_forward"):
			move = "move_right_forward"
		if Input.is_action_pressed("move_right") && Input.is_action_pressed("move_backward"):
			move = "move_right_backward"
		if Input.is_action_pressed("move_left") && Input.is_action_pressed("move_backward"):
			move = "move_left_backward"
		if Input.is_action_pressed("move_left") && Input.is_action_pressed("move_forward"):
			move = "move_left_forward"
		player_anim.play(move)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		player_anim.stop()
		image.frame_coords.y = 6
		
	count_coin(str(coin))
	
	move_and_slide()

func count_coin(x):
	$CanvasLayer/Label.text = "coin: "+x
