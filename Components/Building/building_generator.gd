extends Node2D
class_name BuildingGenerator

signal generated

@export var rooms_count = 3
@export var Duster: PackedScene
@export var image_width = 12
@export var image_height = 12
@export var min_length = 2
@export var max_length = 6
var random_len = 0: get = _get_random_size

func _get_size():
	return image_width * image_height
func _get_random_size():
	return randi_range(min_length/2, max_length/2) * 2 + 1

const max_depth = 10

@onready var map = $Building/RoomMap as TileMap
@onready var rooms: Array[Rect2i] = []
var duster: Node2D
func _ready():
	generate()
	generated.connect(func (): Coins.on_new_building(rooms_count))


func generate():
	map.clear_layer(Building.RoomMapLayers.Ground)
	map.clear_layer(Building.RoomMapLayers.Dirt)
	rooms = []
	var generated_map = Image.create(image_width, image_height, false, Image.FORMAT_L8)

	while rooms.size() < rooms_count:
		var width = random_len
		var height = random_len
		var coords = find_coords_for(generated_map, width, height)
		if (!coords):
			generated_map.fill_rect(rooms.pop_back(), Color.BLACK)
			continue
		var room_rect = Rect2i(coords as Vector2i, Vector2i(width, height))
		rooms.append(room_rect)
		generated_map.fill_rect(room_rect, Color.WHITE)

	var centers = rooms.map(func (room): return room.get_center())
	while centers.size() > 1:
		var center_horizontal = centers.pop_back() as Vector2i
		var center_vertical = centers.pick_random() as Vector2i
		var vertical_length = center_horizontal.x - center_vertical.x
		var horizontal_length = center_vertical.y - center_horizontal.y

		var vertical_line = Rect2i(
				center_vertical,
				Vector2i(vertical_length, -sign(vertical_length))
		)
		var horizontal_line = Rect2i(
				center_horizontal,
				Vector2i(sign(horizontal_length), horizontal_length)
		)
		generated_map.fill_rect(vertical_line, Color.WHITE)
		generated_map.fill_rect(horizontal_line, Color.WHITE)

	var i = 0
	for pixel in generated_map.get_data():
		var x = i % image_width
		var y = i / image_height
		var is_ground =  pixel == 255
		var ground = Vector2(0, 0) if is_ground else Vector2(-1, -1) #Vector2(0, 2)
		map.set_cell(
				Building.RoomMapLayers.Ground,
				map.local_to_map(RoomMap.to_isometric * Vector2(x, y) * RoomMap.tile_size),
				0,
				ground
		)
		i += 1
	
	if (duster):
		remove_child(duster)
	duster = Duster.instantiate()
	duster.position = RoomMap.to_isometric * Vector2(rooms.pick_random().get_center()) * RoomMap.tile_size
	duster.map = map
	add_child(duster)
	$Building.refresh()
	generated.emit()

func find_coords_for(image: Image, width: int, height: int):
	var found = false
	var count = 0
	var found_coords = Vector2i(1, 1)
	while not found and count < max_depth:
		var possible_spot = Rect2i(
				randi_range(0, image.get_width() - width), 
				randi_range(0, image.get_height() - height),
				width + 2,
				height + 2
		)
		var sub_image = image.get_region(possible_spot)
		if not sub_image.get_data().has(255):
			found_coords += possible_spot.position
			found = true
		count += 1
	return found_coords if found else null
