extends TextureProgress

func _ready():
	pass

func _on_hit_guy(newHealth):
	value = newHealth
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
