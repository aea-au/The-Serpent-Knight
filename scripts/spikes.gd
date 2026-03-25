# spikes.gd
extends Node2D

func _on_kill_zone_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		var player = area.get_parent()
		player.take_damage(1, global_position)
