extends Area3D

@onready var player = get_parent().get_parent().get_node("Player")

const ROT_SPEED = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_y(deg_to_rad(ROT_SPEED))

func _on_body_entered(body):
	if body.name == "Player":
		player.coin += 1
		queue_free()
