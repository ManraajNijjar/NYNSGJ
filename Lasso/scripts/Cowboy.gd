extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var ropeObject = preload("res://assets/rope.tscn")
var grappleRopeObject = preload("res://assets/grapple_rope.tscn")
var lassoing = false;
var lassoMesh = null;
@export var lassoTarget : Node3D;
var lassoCenter = null;
@export var horse : CharacterBody3D;
@onready var hand  = $Hand;

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var lassoPoint: Vector3 = screenPointToRayForLasso();
				if lassoPoint != Vector3.ZERO && lassoing == false:
					lassoMesh = createLine(hand.position, lassoPoint);
					lassoing = true;
			else:
				lassoing = false;
				if lassoMesh != null:
					lassoMesh.queue_free();
					lassoMesh = null;
			
		

func createLine(start, end) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new();
	var material := ORMMaterial3D.new();

	mesh_instance.mesh = immediate_mesh;

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material);
	immediate_mesh.surface_add_vertex(start);
	immediate_mesh.surface_add_vertex(end);
	immediate_mesh.surface_end();

	material.shading_mode = ORMMaterial3D.SHADING_MODE_UNSHADED;
	material.albedo_color = Color(1, 0, 0);
	add_child(mesh_instance);
	return mesh_instance;

func _process(delta):
	hand.look_at(screenPointToRay(), Vector3.UP);
	if lassoMesh != null && lassoing && lassoTarget != null:
		updateLassoMesh();
	pass

func updateLassoMesh():
	lassoMesh.mesh.clear_surfaces();
	var material := ORMMaterial3D.new();
	material.shading_mode = ORMMaterial3D.SHADING_MODE_UNSHADED;
	material.albedo_color = Color(1, 0, 0);
	lassoMesh.mesh.surface_begin(Mesh.PRIMITIVE_LINES, material);
	lassoMesh.mesh.surface_add_vertex(hand.position);
	#if(horse != null):
		#lassoMesh.mesh.surface_add_vertex(horse.global_position);
	#if(lassoCenter != null):
		#var handMinusX = 1;
		#var handMinusZ = 1;
		#if hand.position.x > lassoCenter.global_position.x:
			#handMinusX = -1;
		#if hand.position.z > lassoCenter.global_position.z:
			#handMinusZ = -1;
		#lassoMesh.mesh.surface_add_vertex(Vector3(lassoCenter.global_position.x + handMinusX, lassoCenter.global_position.y, lassoCenter.global_position.z + handMinusZ));
		#lassoMesh.mesh.surface_add_vertex(lassoCenter.global_position);
	#else:
		#lassoMesh.mesh.surface_add_vertex(lassoTarget.global_position);
	lassoMesh.mesh.surface_add_vertex(lassoTarget.global_position);

	#lassoMesh.mesh.surface_add_vertex(lassoTarget.global_position + Vector3(lassoTarget.scale.x/2, 0, 0));
	lassoMesh.mesh.surface_end();

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	

	move_and_slide()

func screenPointToRay():
	var spaceState = get_world_3d().direct_space_state
	var mousePos = get_viewport().get_mouse_position()
	var camera = get_tree().root.get_camera_3d()
	var rayOrigin = camera.project_ray_origin(mousePos)
	var rayEnd = rayOrigin + camera.project_ray_normal(mousePos) * 1000
	var temp = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd);
	temp.collision_mask = 1;
	var rayArray = spaceState.intersect_ray(temp);
	if rayArray.has("position"):
		return rayArray["position"]
	return Vector3.ZERO

func screenPointToRayForLasso():
	var spaceState = get_world_3d().direct_space_state
	var mousePos = get_viewport().get_mouse_position()
	var camera = get_tree().root.get_camera_3d()
	var rayOrigin = camera.project_ray_origin(mousePos)
	var rayEnd = rayOrigin + camera.project_ray_normal(mousePos) * 1000
	var temp = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd);
	temp.collision_mask = 1;
	var rayArray = spaceState.intersect_ray(temp);
	if rayArray.has("position"):
		if rayArray["collider"].is_in_group("Lassoable"):
			print(rayArray["collider"].global_position);
			print(rayArray["collider"].get_name());
			lassoTarget = rayArray["collider"];
			if lassoTarget.has_node("LassoCenter") != null:
				print("found lasso point");
				lassoCenter = lassoTarget.get_node("LassoCenter");
			return rayArray["collider"].global_position;
		return rayArray["position"]
	return Vector3.ZERO

#var grappleRope = grappleRopeObject.instantiate();
				#add_child(grappleRope);
				#var distanceGrapple = lassoPoint - global_position;
				#grappleRope.scale = Vector3(0.1, distanceGrapple.length(), 0.1);
				#grappleRope.rotation.x = global_position.angle_to(lassoPoint);
				#var rope = ropeObject.instantiate();
				#add_child(rope);
				#rope.spawn_rope(global_position, screenPointToRay());
				#lassoing = true;