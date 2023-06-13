@tool
extends Resource
class_name CustomizablePackedScene

@export var scene: PackedScene:
	set(value):
		scene = value
		overrides = {}
		notify_property_list_changed()

var overrides: Dictionary = {}

func _get(property):
	if scene != null:
		if not property in overrides:
			return scene.instantiate().get_script().get_property_default_value(property)
		else:
			return overrides[property]

func _set(property, value):
	if scene != null:
		overrides[property] = value

func _get_property_list():
	if scene != null:
		return (
			scene.instantiate().get_script().get_script_property_list()
				.filter(func(property): return property["usage"] & PROPERTY_USAGE_EDITOR != 0 and \
												property["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE)
		)
	else:
		return []
	
func instantiate() -> Node:
	var node = scene.instantiate()
	
	for property in overrides:
		node.set(property, overrides[property])
	
	return node
