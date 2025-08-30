extends Control

func _ready():
	get_tree().paused = false

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://World.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
