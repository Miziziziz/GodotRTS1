extends Spatial

const MOVE_MARGIN = 20
const MOVE_SPEED = 30

const ray_length = 1000
onready var cam = $Camera

func _process(delta):
	var m_pos = get_viewport().get_mouse_position()
	calc_move(m_pos, delta)
	if Input.is_action_just_pressed("main_command"):
		move_all_units(m_pos)

func calc_move(m_pos, delta):
	var v_size = get_viewport().size
	var move_vec = Vector3()
	if m_pos.x < MOVE_MARGIN:
		move_vec.x -= 1
	if m_pos.y < MOVE_MARGIN:
		move_vec.z -= 1
	if m_pos.x > v_size.x - MOVE_MARGIN:
		move_vec.x += 1
	if m_pos.y > v_size.y - MOVE_MARGIN:
		move_vec.z += 1
	move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation_degrees.y)
	global_translate(move_vec * delta * MOVE_SPEED)

func move_all_units(m_pos):
	var result = raycast_from_mouse(m_pos, 1)
	if result:
		get_tree().call_group("units", "move_to", result.position)

func raycast_from_mouse(m_pos, collision_mask):
	var ray_start = cam.project_ray_origin(m_pos)
	var ray_end = ray_start + cam.project_ray_normal(m_pos) * ray_length
	var space_state = get_world().direct_space_state
	return space_state.intersect_ray(ray_start, ray_end, [], collision_mask)