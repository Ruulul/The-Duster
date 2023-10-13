extends CharacterBody2D

@export var speed = 1.0
@export var map: TileMap

@onready var navigation_agent = $NavigationAgent2D
@onready var targets_list: PackedVector2Array = []

var states: Dictionary = {
	move = move,
	clear_dust = clear_dust,
	wait = wait,
	cleaning_dust = func (): pass,
}
@onready var state: Callable = states.wait


func set_target(target: Vector2) -> void:
	navigation_agent.target_position = target

func _input(event):
	if event.is_action_pressed("select"):
		var mouse_position = get_viewport().get_mouse_position()
		var mouse_position_on_map = map.local_to_map(map.to_local(mouse_position))
		var map_rect = map.get_used_rect()
		if map_rect.has_point(mouse_position_on_map):
			targets_list.append(mouse_position)

func _physics_process(delta):
	state.call()

func wait() -> void:
	$ColorRect.color = Color.PURPLE
	if not targets_list.is_empty():
		set_target(targets_list[0])
		targets_list.remove_at(0)
		state = states.move

func clear_dust() -> void:
	$ColorRect.color = Color.DARK_KHAKI
	state = states.cleaning_dust

	get_tree().create_timer(0.5).timeout.connect(func ():
			var current_tile_coords = map.local_to_map(map.to_local(global_position))
			var neighboors_tiles = map.get_surrounding_cells(current_tile_coords)
			neighboors_tiles.append(current_tile_coords)

			for coords in neighboors_tiles:
				map.set_cell(Building.RoomMapLayers.Dirt, coords, 0, get_new_dirt_atlas_coords(coords))
			
			state = states.clear_dust if not neighboors_tiles.all(is_coord_clear) else states.wait
	)

func move() -> void:
	if navigation_agent.is_navigation_finished():
		state = states.clear_dust
		return
	$ColorRect.color = Color.DARK_BLUE
	velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * speed * 32.0
	move_and_slide()

func get_new_dirt_atlas_coords(coords):
	var current_dirt = map.get_cell_atlas_coords(Building.RoomMapLayers.Dirt, coords)
	var previous_dirt_index = Building.dirt_levels.find(current_dirt) - 1
	var previous_dirt = Vector2i(-1, -1)
	if previous_dirt_index >= 0:
		previous_dirt = Building.dirt_levels[previous_dirt_index]
	return previous_dirt

func is_coord_clear(coords):
	return map.get_cell_atlas_coords(Building.RoomMapLayers.Dirt, coords) == Vector2i(-1, -1)
