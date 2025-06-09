@tool
extends EditorScript

# From https://docs.godotengine.org/en/stable/tutorials/plugins/running_code_in_the_editor.html#running-one-off-scripts-using-editorscript

func _run():
	for node in get_all_children(get_scene()):
		if node is TileManager:
			# Don't operate on instanced subscene children, as changes are lost
			# when reloading the scene.
			# See the "Instancing scenes" section below for a description of `owner`.
			var is_instanced_subscene_child = node != get_scene() and node.owner != get_scene()
			if not is_instanced_subscene_child:
				node.SpawnTiles()

# This function is recursive: it calls itself to get lower levels of child nodes as needed.
# `children_acc` is the accumulator parameter that allows this function to work.
# It should be left to its default value when you call this function directly.
func get_all_children(in_node, children_acc = []):
	children_acc.push_back(in_node)
	for child in in_node.get_children():
		children_acc = get_all_children(child, children_acc)

	return children_acc
