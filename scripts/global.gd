extends Node

const PAUSE = 0
const PLAY = 1
const DIALOGUE = 2

var game_state = 1

func _game_init():
	game_state = 1

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if game_state == PLAY:
			game_state = PAUSE
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_tree().paused = true
		elif game_state == PAUSE:
			game_state = PLAY
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			get_tree().paused = false
