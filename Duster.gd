extends CharacterBody2D

@export var speed = 1.0
@export var map: TileMap

@onready var navigation_agent = $NavigationAgent2D

var states: Dictionary = {
	move = move,
	clear_dust = clear_dust,
	wait = wait,
	cleaning_dust = func (): pass,
}
@onready var state: Callable = states.wait


func set_target(target: Vector2) -> void:
	navigation_agent.target_position = target

func _physics_process(delta):
	state.call()

func wait() -> void:
	$ColorRect.color = Color.PURPLE
	if Input.is_action_just_pressed("select"):
		set_target(get_viewport().get_mouse_position())
		state = states.move

func clear_dust() -> void:
	$ColorRect.color = Color.DARK_KHAKI
	state = states.cleaning_dust

	get_tree().create_timer(0.5).timeout.connect(func ():
			var current_tile_coords = map.local_to_map(map.to_local(global_position))
			var current_dirt = map.get_cell_atlas_coords(Building.RoomMapLayers.Dirt, current_tile_coords)
			var previous_dirt_index = Building.dirt_levels.find(current_dirt) - 1
			if previous_dirt_index >= 0:
				var previous_dirt = Building.dirt_levels[previous_dirt_index]
				map.set_cell(Building.RoomMapLayers.Dirt, current_tile_coords, 0, previous_dirt)
			else:
				map.set_cell(Building.RoomMapLayers.Dirt, current_tile_coords, -1, Vector2i(-1, -1))
			state = states.wait
	)

func move() -> void:
	if navigation_agent.is_navigation_finished():
		state = states.clear_dust
		return
	$ColorRect.color = Color.DARK_BLUE
	velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * speed * 32.0
	move_and_slide()
