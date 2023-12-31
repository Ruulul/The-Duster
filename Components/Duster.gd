extends CharacterBody2D
class_name Duster

@export var map: TileMap

@export_group("stats")
@export var cleaning_radius: int = 0
@export var speed = 1.0
@export var cleaning_speed = 1.0

@onready var navigation_agent = $NavigationAgent2D as NavigationAgent2D
@onready var dust_menu = $"CanvasLayer/Dust Upgrades" as MenuButton
@onready var targets_list: PackedVector2Array = []
@onready var cleaning_targets: PackedVector2Array = []

var states: Dictionary = {
	move = move,
	clear_dust = clear_dust,
	wait = wait,
	cleaning_dust = func (): pass,
}
@onready var state: Callable = states.wait

func _draw():
	if not navigation_agent.is_navigation_finished():
		draw_circle(to_local(navigation_agent.target_position), 5.0, Color.DARK_BLUE)
	for target in targets_list:
		draw_circle(to_local(map.to_global(map.map_to_local(target))), 5.0, Color.BROWN)
	for target in cleaning_targets:
		draw_circle(to_local(map.to_global(map.map_to_local(target))), 5.0, Color.GREEN)


func set_target(target: Vector2) -> void:
	navigation_agent.target_position = target
func set_next_target():
	var points = Array(targets_list).map(func (point): return map.to_global(map.map_to_local(point))) \
				.map(func (coord): return global_position.distance_to(coord))
	var closest_point = points.min()
	var closest_index = points.find(closest_point)
	if closest_index >= 0:
		set_target(map.to_global(map.map_to_local(targets_list[closest_index])))
	targets_list.remove_at(closest_index)

func _input(event):
	if event.is_action_pressed("select") and not dust_menu.is_hovered():
		var mouse_position = map.local_to_map(
			map.to_local(
				$Camera2D.get_global_mouse_position()
			)
		)
		var map_rect = map.get_used_rect()
		if map_rect.has_point(mouse_position):
			if targets_list.has(mouse_position):
				targets_list.remove_at(targets_list.find(mouse_position))
				if navigation_agent.target_position == map.to_global(map.map_to_local(mouse_position)):
					set_next_target()
			else:
				targets_list.append(mouse_position)

func _physics_process(delta):
	state.call()
	if state in [states.move]:
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = position.direction_to(navigation_agent.get_next_path_position()).x < 0
	else:
		$AnimatedSprite2D.play("idle")
	queue_redraw()

func wait() -> void:
	if not targets_list.is_empty():
		set_next_target()
		state = states.move

func clear_dust() -> void:
	state = states.cleaning_dust
	cleaning_targets.append_array(get_target_tiles())

	get_tree().create_timer(1 / cleaning_speed).timeout.connect(func ():
			var collected_dust = 0
			var target_tiles = Array(cleaning_targets)
			cleaning_targets.clear()

			for coords in target_tiles:
				var new_dirt_tile = get_new_dirt_tile(coords)
				if map.get_cell_alternative_tile(Building.RoomMapLayers.Dirt, coords) != new_dirt_tile:
					collected_dust += 1
				map.set_cell(Building.RoomMapLayers.Dirt, coords, 0, Dust.dirt, new_dirt_tile)
			
			Dust.add(collected_dust)
			
			state = states.clear_dust if not target_tiles.all(is_coord_clear) else states.wait
	)

func move() -> void:
	if navigation_agent.is_navigation_finished():
		state = states.clear_dust
		return
	velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * speed * 32.0
	move_and_slide()
	
func get_target_tiles() -> Array:
	var square_side: int = 1 + 2 * cleaning_radius
	var origin_tile_position = \
			RoomMap.to_isometric.affine_inverse() \
			*  (map.to_local(global_position) / RoomMap.tile_size) \
			+ Vector2(-cleaning_radius, -cleaning_radius)
	var results: Array[Vector2] = []
	for y in range(square_side):
		for x in range(square_side):
			results.append(origin_tile_position + Vector2(x, y))
	return results.map(func (coord):
		return map.local_to_map(RoomMap.to_isometric * coord * RoomMap.tile_size)
	)

func get_new_dirt_tile(coords) -> int:
	var current_dirt = map.get_cell_alternative_tile(Building.RoomMapLayers.Dirt, coords)
	var previous_dirt_index = Dust.dirt_levels.find(current_dirt) - 1
	var previous_dirt = -1
	if previous_dirt_index >= 0:
		previous_dirt = Dust.dirt_levels[previous_dirt_index]
	return previous_dirt

func is_coord_clear(coords) -> bool:
	return map.get_cell_atlas_coords(Building.RoomMapLayers.Dirt, coords) == Vector2i(-1, -1)
