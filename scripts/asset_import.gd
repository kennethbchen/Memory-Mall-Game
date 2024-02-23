@tool
extends EditorScenePostImport

# Takes every immediate child of the scene and saves it to a resource file.

# Called right after the scene is imported and gets the root node.
func _post_import(scene: Node):
	
	if not DirAccess.dir_exists_absolute("res://imported_assets/"):
		DirAccess.make_dir_absolute("res://imported_assets/")
		
	for child in scene.get_children():
		var obj_scene: PackedScene = PackedScene.new()
		
		var node = child
		node.position = Vector3.ZERO
		var result = obj_scene.pack(node)
		

		#print(scene.get_path())
		if result == OK:
			var error = ResourceSaver.save(obj_scene, "res://imported_assets/" + child.name + ".tscn")
			if error != OK:
				push_error("An error occurred while saving the scene to disk.")
				push_error(error)

	return scene
