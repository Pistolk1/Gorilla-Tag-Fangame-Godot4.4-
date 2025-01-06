extends RigidBody3D

var speed = randf_range(-0.05, -0.15) # Random speed between -0.05 and -0.15
var jump_force = 15.0 # Force applied when the NPC jumps
var jump_timer = 0 # Timer to control when the NPC jumps

func _ready():
	set_process(true)

func _physics_process(delta):
	var direction = -transform.basis.z.normalized() # Forward direction is negative Z
	var current_rotation = rotation_degrees
	current_rotation.x = 0
	current_rotation.z = 0
	rotation_degrees = current_rotation

	# Check for collisions in the direction the NPC is moving
	var space_state = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = global_transform.origin
	ray_query.to = global_transform.origin + direction * 2
	var result = space_state.intersect_ray(ray_query)

	if result: # If there is a collision, find a new direction to move
		direction = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
	else: # If there is no collision, make the NPC jump
		jump_timer += delta
		if jump_timer > randf_range(2, 5): # Jump every 2 to 5 seconds
			apply_central_impulse(Vector3(0, jump_force, 0))
			jump_timer = 0

	apply_central_impulse(direction * speed)
