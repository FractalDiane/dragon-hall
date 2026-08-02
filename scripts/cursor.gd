class_name Cursor
extends Decal

func _process(_delta: float) -> void:
	#var mouse_pos := get_viewport().get_mouse_position()
	##var depth := camera.project_ray_origin(get_viewport().get_mouse_position()).y
	##var depth := camera.project_ray_origin(mouse_pos) + camera.project_ray_normal(mouse_pos) * 10000
	#var origin := camera.project_ray_origin(mouse_pos)
	#var destination := origin + camera.project_ray_normal(mouse_pos) * 10000
	#var query := PhysicsRayQueryParameters3D.create(origin, destination)
	#var result := get_world_3d().direct_space_state.intersect_ray(query)
	##print(result.)
	##print(depth)
	##var pos := camera.project_position(get_viewport().get_mouse_position(), depth)
	#var pos: Vector3 = result["position"]
	#position.x = pos.x
	#position.z = pos.z
	pass
