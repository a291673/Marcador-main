# FONT: https://fonts.google.com/specimen/Indie+Flower
extends Node2D

signal digit_key(digit)
signal pause(mode)

const NEG = -10
const Ratio = [0, 20, 40, 60, 70, 80, 85, 90, 95, 100]
const VX = [[50,80], [90,120], [130,150], [150,180], [190,220]]
const VY = [[30,60], [55,90], [80,120], [110,150], [150,190]]
var key = 0
const Digits = [
	 preload("res://images/0.png"),
	 preload("res://images/1.png"),
	 preload("res://images/2.png"),
	 preload("res://images/3.png"),
	 preload("res://images/4.png"),
	 preload("res://images/5.png"),
	 preload("res://images/6.png"),
	 preload("res://images/7.png"),
	 preload("res://images/8.png"),
	 preload("res://images/9.png"),
]
var screenH
var screenW
var level = 0
var score = 0
var left = 0
var gamer = null
var nwait = 0
var penalty = NEG
var points = 0
var gondo
var gondoN = 10

func _ready():
	var scr = get_viewport_rect().size
	screenW = scr.x
	screenH = scr.y
	randomize()
	key = int(rand_range(0,10))
	print(key)
	z_index = 1
	reset()
	
func _input(event):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	elif Input.is_action_pressed("pause"): 
		# Proy/Mapa-Entrada/pause=SPACE
		# Property/PauseMode/Process
		var pause = not get_tree().paused
		get_tree().paused = pause
		$refresh.paused = pause 
		$start.paused = pause
		emit_signal("pause", pause)
				
func emit(id):
	get_tree().get_root().set_disable_input(true)
	key = id
	gamer = key
	emit_signal("digit_key", key)
	start()

func get_vel():
	var factor = 2.0
	var mx = VX.size() 
	var n = round(level / factor)
	var f = 1.0
	if n >= mx:
		n = mx - 1
		f = (level + 1.0) / (factor * mx)
	return f * Vector2(rand_range(VX[n][0],VX[n][1]),rand_range(VY[n][0],VY[n][1])).rotated(rand_range(0.4, PI/2))

func start():
	$end.stop()
	$start.stop()
	$wait1.start()
	Engine.time_scale = 1.0

func update_score(id):
	left += 1
	if id==gamer or 9==left:
		score_replay()

func reset():
	gondo = int(rand_range(0,9))
	$search.setImage(gondo)
	penalty = NEG
	level += 1
	left = 0
	nwait = 0
	gamer = null
	$start.start()
	get_tree().get_root().set_disable_input(false)

func print_score():
	$score_label.text = "Level: "+str(level)+" Points: "+str(score)+" Gondo: "+str(gondo)

func score_and_reset(ratio, tie=false):
	$end.pitch_scale = 1.5 if tie else 1.0 # empate
	$end.play()
	print_score()
		
func score_replay():
	var pts = Ratio[left]
	if 0==score: score = pts
	score_and_reset(pts)

func _on_end_finished():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Main.tscn")

func _on_wait1_timeout():
	$wait2.start()

func _on_wait2_timeout():
	var p = penalty / 10 # higher penalty if digit was late
	nwait += 1 # wait longer if more digits & less score
	match left:
		9: score_and_reset(100+p)
		8: if nwait>1: score_and_reset(95+p, true)
		7: if nwait>2: score_and_reset(90+p, true)
		6: if nwait>3: score_and_reset(80+p, true)
		_: if nwait>4: score_and_reset(70+p, true)

func endthis():
	$end.play()
func _on_refresh_timeout():
	print_score()
