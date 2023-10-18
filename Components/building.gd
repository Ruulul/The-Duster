extends Node2D
class_name Building

enum Type {
	Comercial,
	House
}

## How many specks of dirt will be generated per second
@export var initial_dust_rate: int = 5
## How long in seconds it takes for the dirt rate decays
@export var dust_decay: int = 20
## By how much does the dirt rate decays (decay/rate dirt/second)
@export var dust_decay_rate: float = 0.5
## Type of the building	
@export var type: Type


@onready var map = $RoomMap as TileMap

var dust_rate
var _decay
# Atlas positions of the 4 dirt levels
const dirt = Vector2i(2, 2)
const dirt_levels = [3, 2, 1, 0]
const dirt_multiplier = 20
enum RoomMapLayers {
	Ground = 0,
	Walls = 1,
	Dirt = 2,
	Objects = 3
}

func _ready():
	await get_parent().ready
	refresh()

func decay():
	_decay += dust_decay_rate
	get_tree().create_timer(dust_decay).timeout.connect(decay)

func refresh():
	_decay = 0.0
	dust_rate = initial_dust_rate
	for i in range(dirt_multiplier * dust_rate):
		dirt_loop()
	decay()
	dirt_loop()
	

func dirt_loop():
	var ground: Array[Vector2i] = map.get_used_cells(RoomMapLayers.Ground)
	ground = ground.filter(
		func (point):
			return map.get_cell_tile_data(RoomMapLayers.Ground, point).get_custom_data('dirtness') > 0
	)
	var chosen_cell = ground.pick_random()
	var previous_dirt = map.get_cell_alternative_tile(RoomMapLayers.Dirt, chosen_cell)
	# the find returns -1 if it is not there, thus with the +1 it puts the dirt at the first stage
	var next_dirt = dirt_levels[
			min(
					dirt_levels.find(previous_dirt) + 1, 
					dirt_levels.size() - 1
				)
		]
	map.set_cell(RoomMapLayers.Dirt, chosen_cell, 0, dirt, next_dirt)
	if _decay > 0:
		get_tree().create_timer(1.0/(dust_rate * get_parent().rooms_count)).timeout.connect(dirt_loop)
