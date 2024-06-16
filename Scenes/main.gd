extends Node2D
@export var spawn: Node2D


func _on_area_2d_body_entered(body):
	body.global_position = spawn.global_position
	pass # Replace with function body.
