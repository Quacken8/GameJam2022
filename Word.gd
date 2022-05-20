extends Node2D

var Letter_scene = preload("res://Letter.tscn")
var letters := ""
var fontWidth := 14
var velocity := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	# inicializuju všechny písmena 
	for i in range(len(letters)):
		var letterString = letters[i]
		var l = Letter_scene.instance()
		l.theLetter = letterString
		l.position.x = i*fontWidth
		l.fixedToWord = true
		l.velocity = velocity
		if not " " in letterString:
			add_child(l)
	
func start(let, pos, vel, rot):
	letters = let
	position = pos
	velocity = vel
	rotation = rot

func _process(delta):
	pass


func _on_VisibilityNotifier_screen_exited():
	queue_free()
