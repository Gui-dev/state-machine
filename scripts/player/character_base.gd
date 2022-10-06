extends KinematicBody2D
class_name CharacterBase


enum STATE_MACHINE {IDLE, WALK, JUMP, JUMP_2, FALL, ATTACK_1, ATTACK_2, ATTACK_3}
var state = STATE_MACHINE.IDLE
var motion := Vector2()
var animation_name := ''
var direction := 0.0
var enter_state := true
onready var sprite: Sprite = get_node('texture')
onready var animation: AnimationPlayer = get_node('animation')
export var speed := 100
export var jump_force := 150
export var gravity := 9.8


func _process(_delta: float) -> void:
  direction = Input.get_axis('ui_left', 'ui_right')


func _physics_process(_delta: float) -> void:
  motion = move_and_slide(motion, Vector2.UP)
  

func _set_animation(anim: String) -> void:
  if animation_name != anim:
    animation_name = anim
    animation.play(animation_name)


func _move_and_slide(delta: float) -> void:
  motion.x = direction * speed
  

func _apply_gravity(delta: float) -> void:
  motion.y += gravity * delta


func _stop_movement() -> void:
  motion.x = 0
  

func _set_flip() -> void:
  if direction:
    sprite.flip_h = false if direction > 0 else true


func _enter_state(new_state) -> void:
  if state != new_state:
    state = new_state
    enter_state = true
