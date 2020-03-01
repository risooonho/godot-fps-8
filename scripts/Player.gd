extends KinematicBody

var defaultSpeed = 5
var speed = 0
var acceleration = 20
var gravity = 9.8
var jumpHeight = 5
var running 

var mouseSensitivity = 0.2

var direction = Vector3()
var velocity = Vector3()
var fall = Vector3()

onready var head = $Head
onready var shootPosition = $Head/Camera/Gun/ShootPosition
onready var bulletScn = preload("res://scenes/Bullet.tscn")

func _ready():
	lock_mouse()

func _process(delta):
	direction = Vector3()
	quit_game()
	apply_gravity(delta)
	run()
	jump()
	move()
	shoot()
	apply_movement(delta)
	
func _input(event):
	if event is InputEventMouseMotion:
		aim(event)
		
func apply_movement(delta):
	direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity = move_and_slide(velocity, Vector3.UP)
	move_and_slide(fall, Vector3.UP)
	
func lock_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
func run():
	if not Input.is_action_pressed("run"):
		speed = defaultSpeed
		running = false
	else:
		speed = defaultSpeed * 2
		running = true
	var moveSpeed = speed if not Input.is_action_pressed("run") else speed * 2

func move():
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z	
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
		
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x	
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x

func quit_game():
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

func apply_gravity(delta):
	if not is_on_floor():
		fall.y -= gravity * delta

func jump():
	if Input.is_action_just_pressed("jump"):
		fall.y = jumpHeight

func aim(mouseEvent: InputEventMouseMotion):
	rotate_y(deg2rad(-mouseEvent.relative.x * mouseSensitivity))
	head.rotate_x(deg2rad(-mouseEvent.relative.y * (mouseSensitivity / 1.5 )))
	head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))

func shoot():
	if Input.is_action_just_pressed("shoot"):
		var bullet = bulletScn.instance()
		bullet.global_transform = shootPosition.global_transform
		bullet.scale = Vector3.ONE
		get_node("/root/Game").add_child(bullet)
