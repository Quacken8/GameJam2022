extends "res://Player.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	startPosition = Vector2(1700, 100)
	respawn()
	Progressbar_scene = get_node("/root/Main/HUD/ProgressBar2")
	self.connect("got_hit", Progressbar_scene, "_on_hit_guy")
	Ammo_scene = get_node("/root/Main/HUD/AmmoLabel2")
	originalColor = "5555ff"
	$ColorRect.color = originalColor
	Lives_scene = get_node("/root/Main/HUD/LivesCounter2")
	opponentNumber = 1
	OtherPlayer_scene = get_node("/root/Main/Player1")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not disabledInput:
		leftShootPressed = Input.is_action_pressed("shootLeft2")
		rightShootPressed = Input.is_action_pressed("shootRight2")
		upShootPressed = Input.is_action_pressed("shootUp2")
		downShootPressed = Input.is_action_pressed("shootDown2")
	
		succ = Input.is_action_pressed("succ2")
		succRelease = Input.is_action_just_released("succ2")
	
		jumpPressed = Input.is_action_pressed("jump2")
		leftPressed = Input.is_action_pressed("left2")
		rightPressed = Input.is_action_pressed("right2")
		downPressed = Input.is_action_pressed("down2")


func _on_VisibilityNotifier2D_screen_exited():
	hit(1000)
