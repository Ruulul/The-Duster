extends Node2D

signal update(new_dust: int)

var dust: int = 0

const dirt = Vector2i(2, 2)
const dirt_levels = [3, 2, 1, 0]
@onready var label = $CanvasLayer/VBoxContainer/Label

func _ready():
	update.emit(dust)

func reset():
	dust = 0
	update.emit(dust)

func _process(_delta):
	position = get_viewport().get_camera_2d().position

func add(increase: int) -> void:
	dust += increase
	update.emit(dust)

func remove(decrease: int) -> void:
	dust -= decrease
	update.emit(dust)

func maybe_remove(decrease: int) -> void:
	if dust - decrease >= 0:
		dust -= decrease
		update.emit(dust)
