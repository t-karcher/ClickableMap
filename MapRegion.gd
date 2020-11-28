extends Area2D
class_name MapRegion

signal region_selected

var shape : PoolVector2Array setget set_shape
var base_color : Color = Color(randf(), randf(), randf(), 0.6)
var has_focus : bool = false

onready var _poly : Polygon2D = $Polygon2D
onready var _coll : CollisionPolygon2D = $CollisionPolygon2D

func set_shape(new_shape: PoolVector2Array):
	_poly.set_polygon(new_shape)
	_poly.color = base_color
	_coll.set_polygon(new_shape)
	shape = new_shape

func _on_MapRegion_mouse_entered():
	_poly.color.a = 1
	has_focus = true

func _on_MapRegion_mouse_exited():
	_poly.color.a = 0.6
	has_focus = false
	
func _input(event):
	if event is InputEventMouseButton and event.pressed and has_focus:
		emit_signal("region_selected")
