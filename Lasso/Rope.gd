extends Node

var RopePiece = preload("res://assets/rope_piece.tscn");
@export var segmentLength = 0.5;
var rope_parts := [];
var rope_close_tolerance := 0.4;

@onready var rope_start_piece = $RopeStartPiece;
@onready var rope_end_piece = $RopeEndPiece;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_rope(start:Vector3, end:Vector3):
	rope_start_piece.global_position = start;
	rope_end_piece.global_position = end;

	start = rope_start_piece.get_node("CollisionShape3D/PinJoint3D").global_position;
	end = rope_end_piece.get_node("CollisionShape3D/PinJoint3D").global_position;

	var distance = start.distance_to(end);
	var segment_amount = distance/segmentLength;
	var spawn_angle = (end - start).normalized();
	print(spawn_angle);
	create_rope(segment_amount, rope_start_piece, end, spawn_angle);

	pass

func create_rope(pieces_amount: int, parent: Object, end_pos:Vector3, spawn_angle: Vector3):
	for i in pieces_amount:
		parent = add_piece(parent, i, spawn_angle);
		parent.set_name("RopePiece_" + str(i));
		rope_parts.append(parent);
		
		var joint_pos = parent.get_node("CollisionShape3D/PinJoint3D").global_position;
		#if joint_pos.distance_to(end_pos) < rope_close_tolerance:
			#break;
	#rope_end_piece.get_node("CollisionShape3D/PinJoint3D").node_a = rope_end_piece.get_path();
	#rope_end_piece.get_node("CollisionShape3D/PinJoint3D").node_b = rope_parts[rope_parts.size()-1].get_path();
	pass

func add_piece(parent: Object, id: int, spawn_angle: Vector3) -> Object:
	var joint : PinJoint3D = parent.get_node("CollisionShape3D/PinJoint3D") as PinJoint3D;
	var piece : Object = RopePiece.instantiate() as Object;
	piece.global_position = joint.global_position;
	piece.rotation = spawn_angle;
	piece.parent = self;
	piece.id = id;
	add_child(piece);
	joint.node_a = parent.get_path();
	joint.node_b = piece.get_path();
	return piece;
