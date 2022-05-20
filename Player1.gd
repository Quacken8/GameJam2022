extends "res://Player.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	startPosition = Vector2(200, 100)
	respawn()
	Progressbar_scene = get_node("/root/Main/HUD/ProgressBar1")
	self.connect("got_hit", Progressbar_scene, "_on_hit_guy")
	Ammo_scene = get_node("/root/Main/HUD/AmmoLabel1")
	originalColor = "55ff55"
	$ColorRect.color = originalColor
	flippedHUD = false
	Lives_scene = get_node("/root/Main/HUD/LivesCounter1")
	opponentNumber = 2

func ugh():
	OtherPlayer_scene = get_node("/root/Main/Player2")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not disabledInput:
		leftShootPressed = Input.is_action_pressed("shootLeft1")
		rightShootPressed = Input.is_action_pressed("shootRight1")
		upShootPressed = Input.is_action_pressed("shootUp1")
		downShootPressed = Input.is_action_pressed("shootDown1")
	
		succ = Input.is_action_pressed("succ1")
		succRelease = Input.is_action_just_released("succ1")
	
		jumpPressed = Input.is_action_pressed("jump1")
		leftPressed = Input.is_action_pressed("left1")
		rightPressed = Input.is_action_pressed("right1")
		downPressed = Input.is_action_pressed("down1")


func _on_VisibilityNotifier2D_screen_exited():
	hit(1000)
