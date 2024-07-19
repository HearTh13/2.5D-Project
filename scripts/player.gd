extends CharacterBody3D

var coin = 0
const SPEED = 2
const JUMP_VELOCITY = 4
@onready var image = $Sprite3D
@onready var player_anim = $PlayerAnimation
@onready var camera = $CameraController
@onready var text_label = $CanvasLayer/Label
@export var sens = 0.1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sens))
		camera.rotate_x(deg_to_rad(-event.relative.y * sens))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-15), deg_to_rad(0))

func _physics_process(delta):
	player_movements(delta)
	move_and_slide()
	set_bar()
	count_coin(str(coin))

func count_coin(x):
	$UI/CanvasLayer/Control/Label.text = x

func set_bar():
	$UI/CanvasLayer/HPBar.value = PlayerAttribute.player_hp
	$UI/CanvasLayer/HPBar.max_value = PlayerAttribute.player_maxHp
	$UI/CanvasLayer/MPBar.value = PlayerAttribute.player_mp
	$UI/CanvasLayer/MPBar.max_value = PlayerAttribute.player_maxMp

func player_movements(delta):
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
