extends KinematicBody2D

var theLetter := "A"
var fixedToWord := true
var velocity := Vector2.ZERO
var damage := 10

onready var gravityAcc = get_tree().root.get_children()[0].gravityAcc

var shotspeed = 2000
func _ready():
	$LetterLable.text = theLetter
	velocity = velocity.normalized()*shotspeed+Vector2.UP*shotspeed/7
	#$LetterDestroyTimer.start()
	

func _physics_process(delta):
	velocity.y += gravityAcc
	var collision = move_and_collide(velocity*delta)
	if collision:
		fixedToWord = false
		if collision.collider.has_method("hit") and not collision.collider.invincible:
			set_collision_layer_bit(1, false)
			set_collision_mask_bit(0, false)
			#change color
			collision.collider.hit(damage)


func _on_LetterDestroyTimer_timeout():
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
