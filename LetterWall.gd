extends KinematicBody2D

var theLetter := "A"
var fontWidth = 14
var succed = false
var velocity = Vector2.ZERO
var scrollVelocity = Vector2(0,-50/0.8)

func _ready():
	$LetterLable.text = theLetter
	$LetterDestroyTimer.start()

func _physics_process(delta):
	if not succed:
		velocity = scrollVelocity
	position+=delta*velocity

func _on_LetterDestroyTimer_timeout():
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
