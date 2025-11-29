extends Control




func _on_button_pressed() -> void:
	get_tree().quit()


func _on_button_2_pressed() -> void:
	get_tree().root.set_meta("story_path", "res://story/story.json")
	get_tree().change_scene_to_file("res://vntemplate.tscn") 
	# store which story JSON to use
	


func _on_button_3_pressed() -> void:
	pass # Replace with function body.


func _on_button_4_pressed() -> void:
	get_tree().change_scene_to_file("res://maps/map_01.tscn")
