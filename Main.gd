extends Node2D

export var gravityAcc := 30.0 

onready var textLeft = 'res://textLeft.txt'
onready var textRight = 'res://textRight.txt'

var Word_scene = preload("res://Word.tscn")
var WallLetter_scene = preload("res://LetterWall.tscn")
var Player1 = preload("res://Player1.tscn")
var Player2 = preload("res://Player2.tscn")

var words = []
var linesLeft = []
var linesRight = []

var totalTime = 0

var started = false

func _ready():
	linesLeft = load_lines(textLeft)
	linesRight = load_lines(textRight)
	randomize()


func start():
	$HUD/Title2.hide()
	$StartTimer.start()
	$DramaTimer.start()
	var p1 = Player1.instance()
	var p2 = Player2.instance()
	p1.hide()
	p2.hide()
	add_child(p1)
	add_child(p2)
	$Player1.ugh()
	#$Player2.ugh()

func load_words(file):
	var f = File.new()
	var toReturn = []
	f.open(file, File.READ)
	while not f.eof_reached(): # iterate through all lines until the end of file is reached
		var line = f.get_line()
		toReturn.append_array(line.split(" "))
	f.close()
	return toReturn

func load_lines(file):
	var f = File.new()
	var toReturn = []
	f.open(file, File.READ)
	while not f.eof_reached(): # iterate through all lines until the end of file is reached
		var line = f.get_line()
		toReturn.append(line)
	f.close()
	return toReturn

#func _process(delta):
#	pass


func _on_LetterScrollTimer_timeout():
	# add new line of text
	var xmargin = 100
	var textL = linesLeft.pop_front()
	if textL == null:
		$LetterScrollTimer.stop()
		return 0

	for i in range(len(textL)):
		var letter = textL[i]
		if letter == " ": continue
		var l = WallLetter_scene.instance()
		l.theLetter = letter
		l.position = Vector2(i*l.fontWidth + xmargin, get_viewport().size.y)
		get_parent().add_child(l)
		
	var textR = linesRight.pop_front()
	if textR == null:
		$LetterScrollTimer.stop()
		return 0

	for i in range(len(textR)):
		var letter = textR[len(textR)-1-i]
		if letter == " ": continue
		var r = WallLetter_scene.instance()
		r.theLetter = letter
		r.position = Vector2(get_viewport().size.x - i*r.fontWidth-xmargin, get_viewport().size.y)
		get_parent().add_child(r)

func _process(delta):
	print(get_parent().get_child_count())
	if Input.is_action_just_pressed("esc"):
		if $HUD/VideoPlayer.is_playing():
			$HUD/VideoPlayer.stop()
			$HUD/VideoPlayer.hide()
			$HUD/VideoPlayer.emit_signal("finished")
		else: 
			get_tree().quit()
	totalTime += delta/50
	if levelOfDrama == 3:
		$HUD/ProgressBar1.value += delta*100
		$HUD/ProgressBar2.value += delta*100

func _on_StartTimer_timeout():
	if not started:
		$HUD/Title1.hide()
		$HUD/Title2.show()
		$StartTimer.start()
		started = true
	else:
		$HUD/Title2.hide()
		$LetterScrollTimer.start()

var levelOfDrama = 0
func _on_DramaTimer_timeout():
	if levelOfDrama == 0:
		$HUD/BottomRect.show()
	else: if levelOfDrama == 1:
		$HUD/ReadyLetter1.show()
		$Player1.show()
		$HUD/ReadyLetter2.show()
		$Player2.show()
		$HUD/Controls1.show()
		$HUD/Controls2.show()
	else: if levelOfDrama == 2:
		$DramaTimer.stop()
		$DramaTimer.wait_time = 1.3
		$DramaTimer.start()
		$HUD/ProgressBar1.show()
		$HUD/ProgressBar2.show()
	else: if levelOfDrama == 3:
		$HUD/LivesCounter1.show()
		$HUD/LivesCounter2.show()
		$HUD/Controls1.hide()
		$HUD/Controls2.hide()
		$DramaTimer.stop()
	
	levelOfDrama += 1


func _on_VideoPlayer_finished():
	$HUD/VideoPlayer.hide()
	$HUD/AudioStreamPlayer.play(39.626)
	start()

