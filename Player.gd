extends KinematicBody2D

const maxWalkSpeed := 300.0
const jumpSpeed := 600.0
const movementControl := 1e-1
var velocity := Vector2.ZERO

var startPosition

onready var opponentNumber
onready var OtherPlayer_scene

var respawnMode = true
var originalColor = "ffffff"
onready var health := 100

onready var lives := 4
onready var Lives_scene

onready var gravityAcc = get_tree().root.get_children()[0].gravityAcc
onready var Progressbar_scene
onready var Ammo_scene

onready var leftShootPressed : int 
onready var rightShootPressed : int 
onready var upShootPressed : int  
onready var downShootPressed : int 
onready var flippedHUD := true

onready var succ : int 
onready var succRelease : int

onready var jumpPressed : int 
onready var leftPressed : int 
onready var rightPressed : int 
onready var downPressed  : int 

var succed = false

signal got_hit
signal died

var invincible = false

var succAmmo = []
const maxAmmo = 10

var ShootLetter_scene = preload("res://Letter.tscn")

var disabledInput = false

func _ready():
	disabledInput = true



onready var allEverSucked = []
func _process(delta):
	if not respawnMode:
		# succing
		var succChosen = false
		var succSpeed = 2000*100
		var inRange = $SuccArea.get_overlapping_bodies()

		if succ and len(succAmmo)<maxAmmo:
			for letter in inRange:
				if letter.is_in_group("Succable"):
					letter.succed = true
					var vectToPlayer = (position-letter.position)
					letter.velocity = vectToPlayer.normalized()*succSpeed/vectToPlayer.length()/vectToPlayer.length()
					if not letter in allEverSucked: allEverSucked.append(weakref(letter))
			var pickUp = $PickUpArea.get_overlapping_bodies()
			for letter in pickUp:
				if letter.is_in_group("Succable"):
					if letter.succed:
						var theChar = letter.theLetter
						succAmmo.append(theChar)
						Ammo_scene.text += theChar
						letter.queue_free()
						if len(succAmmo)>=maxAmmo: succ = not succ
	
		if succRelease or not succ:
			for letter in allEverSucked:
				if not (!letter.get_ref()):
					letter.get_ref().succed = false
			allEverSucked = []
	
	
		#walking
	
		var targetX := (rightPressed-leftPressed)*maxWalkSpeed
		velocity.x = lerp(velocity.x, targetX, movementControl)
		velocity.y += gravityAcc
		if is_on_floor():
			velocity.y = -jumpPressed*jumpSpeed
	
		move_and_slide(velocity, Vector2.UP)
	
		#shooting

	
		var shootDir = Vector2(rightShootPressed-leftShootPressed, downShootPressed-upShootPressed)
		if shootDir.length() != 0 and $ShotDelay.is_stopped() and len(succAmmo)!=0:
			$ShotDelay.start()
			var shootChar
			if flippedHUD:
				shootChar = succAmmo.pop_front()
				var strr = Ammo_scene.text
				strr.erase(0,1)
				Ammo_scene.text = strr
			else:
				shootChar = succAmmo.pop_back()
				var strr = Ammo_scene.text
				strr.erase(len(succAmmo),1)
				Ammo_scene.text = strr
		
			var shl = ShootLetter_scene.instance()
			shl.position = position+ $ColorRect.rect_size/1*shootDir+Vector2(0,15)
			shl.velocity = shootDir*500
			shl.theLetter = shootChar
			get_parent().add_child(shl)
	else:
		
		velocity = Vector2(rightPressed-leftPressed, downPressed-jumpPressed)*100
	
		move_and_slide(velocity, Vector2.UP)

	
func hit(damage):
	invincible = true
	$iframesTimer.start()
	$ColorRect.color = "ff0000"
	health = max(0, health - damage)
	emit_signal("got_hit", health)
	set_collision_layer_bit(0, false)
	if health == 0:
		emit_signal("died")
		$iframesTimer.stop()
		$AnimatedSprite.animation = "slowBeeps"
		$AnimatedSprite.show()
		$AnimatedSprite.play()
		invincible = true
		lives -= 1
		if lives == 3:
			Lives_scene.get_node("4lives").hide()
			Lives_scene.get_node("3lives").show()
		else: if lives == 2:
			Lives_scene.get_node("3lives").hide()
			Lives_scene.get_node("2lives").show()
		else: if lives == 1:
			Lives_scene.get_node("2lives").hide()
			Lives_scene.get_node("1lives").show()
		else: if lives == 0:
			Lives_scene.get_node("1lives").hide()
			Lives_scene.get_node("0lives").show()
		if lives == 0:
			position.y = 10000
			var Victory_scene = get_node("/root/Main/HUD/VictoryLabel")
			Victory_scene.text = "Player %s wins!" %opponentNumber
			Victory_scene.show()
			OtherPlayer_scene.lives = 100
			
		else:
			respawn()

func respawn():
	position = startPosition
	respawnMode = true
	$ColorRect.color = originalColor
	set_collision_mask_bit(2, false)
	set_collision_layer_bit(0, false)
	set_collision_mask_bit(0, false)
	$respawnTimer.start()

func _on_iframesTimer_timeout():
	invincible = false
	set_collision_layer_bit(0, true)
	$ColorRect.color = originalColor


var firstWarning = true
func _on_respawnTimer_timeout():
	if firstWarning:
		$AnimatedSprite.animation = "fasterBeeps"
		$AnimatedSprite.play()
		if lives != 4:
			$respawnTimer.wait_time/=2
		$respawnTimer.start()
		firstWarning = false
	else:
		$AnimatedSprite.stop()
		$AnimatedSprite.hide()
		if lives != 4:
			$respawnTimer.wait_time*=2
		else: disabledInput = false
		health = 100
		Progressbar_scene.value = 100
		set_collision_mask_bit(2, true)
		boom()
		set_collision_mask_bit(0, true)
		set_collision_layer_bit(0, true)
		invincible = false
		firstWarning = true
		respawnMode = false

func boom():
	var inRange = $SuccArea.get_overlapping_bodies()
	
	for body in inRange:
		if body.has_method("hit"):
			body.hit(50)
		if not body.get("velocity") == null:
			if not body.get("succed") == null: body.succed = true
			body.velocity += (body.position-position).normalized()*5000
