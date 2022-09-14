extends Area2D

const COLOR_OFF=Color(0.25,0.25,0.25,0.5)
const COLOR_ON=Color.red

onready var color_rect=$Control/ColorRect
onready var hbox_layer=$"%HBox Layer"
onready var hbox_mask=$"%HBox Mask"

func _ready():
	update_collision_bits(null)
	var c=get_checkboxes()
	for a in c:
		for n in a:
			n.connect("toggled",self,"update_collision_bits")

# Retrieve checkbox controls.
func get_checkboxes()->Array:
	var layers=hbox_layer.get_children()
	layers.remove(0)
	var masks=hbox_mask.get_children()
	masks.remove(0)
	return [layers,masks]

# Update all bits based on checkboxes.
func update_collision_bits(_x):
	var c=get_checkboxes()
	for i in c[0].size():
		set_collision_layer_bit(i,c[0][i].pressed)
	for i in c[1].size():
		set_collision_mask_bit(i,c[1][i].pressed)

# Change rectangle color when collision happens.
func _on_area_entered(_area):
	color_rect.color=COLOR_ON
func _on_area_exited(_area):
	color_rect.color=COLOR_OFF

# Dragging.
var grab_pos:Vector2=Vector2.UP
func _on_VBoxContainer_gui_input(event):
	if event is InputEventMouseButton:
		grab_pos=event.position if event.pressed else Vector2.UP
	if event is InputEventMouseMotion and grab_pos!=Vector2.UP:
		position=position+event.position-grab_pos
