extends Control

signal onTransitionFinish
@onready var dialogue = $dialouge/RichTextLabel
@onready var name_label = $name/Label
@onready var bg = $bg
@onready var colorRect = $transition/ColorRect
@onready var colorRect2 = $transition/ColorRect2
@onready var animation = $transition/AnimationPlayer
@onready var slots = [
	$Character/chara1/TextureRect,
	$Character2/chara1/TextureRect,
	$Character3/chara1/TextureRect
]

var typing_speed := 0.5
var story_data := []
var settings := []
var current_index := 0

func _ready():
	var story_path = get_tree().root.get_meta("story_path")
	load_story(story_path)
	colorRect.visible = false
	animation.animation_finished.connect(_on_animation_finish)
	play_next_line()
	#print(story_data)
	
func _on_animation_finish(anim_name):
	if anim_name == "fadetoblack":
		onTransitionFinish.emit()
		animation.play("fadetonormal")
	elif anim_name == "fadetonormal":
		colorRect.visible = false
	
	
func transition():
	colorRect.visible = true
	animation.play("fadetoblack")

func play_next_line():
	if current_index >= story_data.size():
		dialogue.text = "END"
		get_tree().change_scene_to_file("res://mainmenu.tscn")
		return
	var line = story_data[current_index]
	var bg_path = line.get("bg", "")
	if bg_path != "":
		transition()
		await onTransitionFinish
		colorRect2.visible = false
		bg.texture = load(bg_path)
		
	name_label.text = line.get("speaker", "")
	dialogue.text = line.get("text", "")
	var sprite_path = line.get("sprite", "")
		
	
	type_text()
	slots[0].visible = true
	if ResourceLoader.exists(sprite_path):
		slots[0].visible = true
		slots[0].texture = load(sprite_path)
	else:
		slots[0].visible = false
	
	
	
	current_index +=1

	
	
func type_text():
	var tween = create_tween()
	tween.tween_property(dialogue, "visible_ratio", 1.0, typing_speed).from(0.0)
	


func load_story(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	var json_data = JSON.parse_string(file.get_as_text())
	if typeof(json_data) == TYPE_ARRAY:
		story_data = json_data
	else:
		push_error("Story file is not a JSON array!")
		

		
		
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		play_next_line()
