extends Node

var RopePiece = preload("res://assets/rope_piece_2d.tscn")
var rope_parts := []
var piece_length := 25
@export var rope_close_tolerance := 25

@onready var rope_start_piece = $RopeStartPiece2D
@onready var rope_end_piece = $RopeEndPiece2D
@onready var rope_final_piece = $RopeFinalPiece2D
var cowboy;
var playerTrack = false;

func _ready():
	cowboy = get_node("/root/Node2D/Cowboy2D");
	pass # Replace with function body.

func _process(delta):
	if playerTrack:
		rope_start_piece.global_position = cowboy.position;
	pass

func spawn_rope(start_pos:Vector2, end_pos:Vector2):
	rope_start_piece.global_position = start_pos;
	rope_end_piece.global_position = end_pos;
	start_pos = rope_start_piece.get_node("CollisionShape2D/PinJoint2D").global_position
	end_pos = rope_end_piece.get_node("CollisionShape2D/PinJoint2D").global_position

	var distance = start_pos.distance_to(end_pos)
	var segment_amount = round(distance / piece_length);
	var spawn_angle = (end_pos - start_pos).angle() - PI/2
	
	create_rope(segment_amount, rope_start_piece, end_pos, spawn_angle);
	pass

func spawn_rope_to_object(start_pos:Vector2, endObject: Object):
	playerTrack = true;

	cowboy.get_node("CollisionShape2D/PinJoint2D").node_b = rope_start_piece.get_path()

	rope_start_piece.global_position = start_pos;
	rope_final_piece.global_position = endObject.global_position
	start_pos = rope_start_piece.get_node("CollisionShape2D/PinJoint2D").global_position
	var end_pos = rope_final_piece.get_node("CollisionShape2D/PinJoint2D").global_position

	var distance = start_pos.distance_to(end_pos)
	var segment_amount = round(distance / piece_length);
	var spawn_angle = (end_pos - start_pos).angle() - PI/2
	
	create_rope_to_object(segment_amount, rope_start_piece, endObject, end_pos, spawn_angle);

func create_rope(pieces_amount: int, parent:Object, end_pos:Vector2, spawn_angle:float)-> void:
	for i in pieces_amount:
		parent = add_piece(parent, i, spawn_angle, 30)
		parent.set_name("rope_piece_"+str(i))
		rope_parts.append(parent)

		var joint_pos = parent.get_node("CollisionShape2D/PinJoint2D").global_position
		if joint_pos.distance_to(end_pos) < rope_close_tolerance:
			break
	rope_end_piece.get_node("CollisionShape2D/PinJoint2D").node_a = rope_end_piece.get_path()
	rope_end_piece.get_node("CollisionShape2D/PinJoint2D").node_b = rope_parts[-1].get_path()

func create_rope_to_object(pieces_amount: int, parent:Object, endObject: Object, end_pos:Vector2, spawn_angle:float)-> void:
	for i in pieces_amount:
		parent = add_piece(parent, i, spawn_angle, 16)
		parent.set_name("rope_piece_"+str(i))
		rope_parts.append(parent)

		var joint_pos = parent.get_node("CollisionShape2D/PinJoint2D").global_position
		if joint_pos.distance_to(end_pos) < rope_close_tolerance:
			break
	rope_final_piece.get_node("CollisionShape2D/PinJoint2D").node_a = rope_final_piece.get_path()
	rope_final_piece.get_node("CollisionShape2D/PinJoint2D").node_b = rope_parts[-1].get_path()
	rope_final_piece.get_node("CollisionShape2D/ConnectingPinJoint2D").node_a = rope_final_piece.get_path()
	rope_final_piece.get_node("CollisionShape2D/ConnectingPinJoint2D").node_b = endObject.get_path()

func add_piece(parent: Object, id:int, spawn_angle:float, layerMaskValue: int) -> Object:
	var joint : PinJoint2D = parent.get_node("CollisionShape2D/PinJoint2D");
	var piece : RigidBody2D = RopePiece.instantiate() as RigidBody2D;
	piece.global_position = joint.global_position;
	piece.rotation = spawn_angle
	piece.parent = self
	piece.id = id
	piece.collision_layer = layerMaskValue;
	add_child(piece)
	joint.node_a = parent.get_path();
	joint.node_b = piece.get_path();
	return piece;

func remove_piece():
	var piece : Object = rope_parts.pop_back()
	var parentPiece : Object = piece.parent;
	print("Parent");
	print(parentPiece);
	print("Parent Node");
	print(parentPiece.get_node("CollisionShape2D/PinJoint2D"));
	parentPiece.get_node("CollisionShape2D/PinJoint2D").node_b = rope_final_piece.get_path()
	piece.queue_free();
