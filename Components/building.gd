extends Node2D
class_name Building

enum Type {
	Comercial,
	House
}

@export var initial_dust_rate: int
@export var dust_decay: int = 10
@export var dust_decay_rate: float = 1.0
@export var rooms_count: int
@export var type: Type

@onready var dust_rate = initial_dust_rate
@onready var _decay = 0.0
# Atlas positions of the 4 dirt levels
const dirt_levels = [Vector2i(2, 2), Vector2i(4, 2), Vector2i(2, 3), Vector2i(4, 3)]
const dirt_multiplier = 20
enum RoomMapLayers {
	Ground = 0,
	Walls = 1,
	Dirt = 2,
	Objects = 3
}

func _ready():
	for i in range(dirt_multiplier * dust_rate):
		dirt_loop()
	decay()
	dirt_loop()

func decay():
	_decay += dust_decay_rate
	get_tree().create_timer(dust_decay).timeout.connect(decay)
func dirt_loop():
	var ground: Array[Vector2i] = $RoomMap.get_used_cells(RoomMapLayers.Ground)
	var chosen_cell = ground.pick_random()
	var previous_dirt = $RoomMap.get_cell_atlas_coords(RoomMapLayers.Dirt, chosen_cell)
	# the find returns -1 if it is not there, thus with the +1 it puts the dirt at the first stage
	var next_dirt = dirt_levels[
			min(
					dirt_levels.find(previous_dirt) + 1, 
					dirt_levels.size() - 1
				)
		]
	$RoomMap.set_cell(RoomMapLayers.Dirt, chosen_cell, 0, next_dirt)
	if _decay > 0:
		get_tree().create_timer(_decay/dust_rate).timeout.connect(dirt_loop)
