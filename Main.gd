extends Node2D

onready var sprite = preload("res://Sprite.tscn")

func _ready():
	for i in range(Score.gondoN):
		if(i%10!=Score.gondo):
			var s = sprite.instance()
			s.id = i
			s.set_scale(Vector2(.5, .5))
			s.set_texture(Score.Digits[i%10])
			add_child(s)
	var s = sprite.instance()
	s.id = Score.gondo
	s.set_scale(Vector2(.5, .5))
	s.set_texture(Score.Digits[Score.gondo])
	add_child(s)

func rem(id):
	remove_child(id)
