@tool
extends EditorScenePostImport

# Takes every immediate child of the scene and saves it to a resource file.

# Called right after the scene is imported and gets the root node.
func _post_import(scene: Node):
	
	if not DirAccess.dir_exists_absolute("res://imported_assets/"):
		DirAccess.make_dir_absolute("res://imported_assets/")
	
	for child in scene.get_children():
		
		
		var filepath = "res://imported_assets/" + child.name + ".tscn"
			
		var obj_scene: PackedScene = PackedScene.new()
		
		var node = child.duplicate()
		node.position = Vector3.ZERO
		
		set_owner_recursive(node, node)
		
		var result = obj_scene.pack(node)
		
		if result == OK:
			var error = ResourceSaver.save(obj_scene, filepath, ResourceSaver.FLAG_CHANGE_PATH | ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS)
			if error != OK:
				push_error("An error occurred while saving the scene to disk.")
				push_error(error)
				
		print("Imported ", child.name)

	return scene

func set_owner_recursive(node: Node, new_owner: Node):
	
	if node != new_owner:
		node.owner = new_owner
	
	for child in node.get_children():
		set_owner_recursive(child, new_owner)
