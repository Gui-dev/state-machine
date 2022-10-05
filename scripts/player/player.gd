extends CharacterBase


func _process(delta: float) -> void:
  match state:
    STATE_MACHINE.IDLE: _state_idle(delta)
    STATE_MACHINE.WALK: _state_walk(delta)
    STATE_MACHINE.JUMP: _state_jump(delta)
    STATE_MACHINE.DOUBLE_JUMP: _state_double_jump(delta)
    STATE_MACHINE.FALL: _state_fall(delta)


func _state_idle(delta: float) -> void:
  _set_animation('idle')
  _apply_gravity(delta)
  _stop_movement()
  
  if direction:
    _enter_state(STATE_MACHINE.WALK)
  
  if Input.is_action_just_pressed('ui_jump'):
    _enter_state(STATE_MACHINE.JUMP)
  

func _state_walk(delta: float) -> void:
  _set_animation('walk')
  _apply_gravity(delta)
  _move_and_slide(delta)
  _set_flip()
  
  if not direction:
    _enter_state(STATE_MACHINE.IDLE)
  
  if Input.is_action_just_pressed('ui_jump'):
    _enter_state(STATE_MACHINE.DOUBLE_JUMP)


func _state_jump(delta: float) -> void:
  _set_animation('jump')
  _apply_gravity(delta)
  _set_flip()
  _move_and_slide(delta)
  
  if enter_state:
    enter_state = false
    motion.y = -jump_force
    
  if motion.y > 0:
    _enter_state(STATE_MACHINE.FALL)


func _state_double_jump(delta: float) -> void:
  _set_animation('jump_2')
  _apply_gravity(delta)
  _set_flip()
  _move_and_slide(delta)
  
  if enter_state:
    enter_state = false
    motion.y = -jump_force
  
  if motion.y > 0:
    _enter_state(STATE_MACHINE.FALL)
    


func _state_fall(delta: float) -> void:
  _set_animation('fall')
  _apply_gravity(delta)
  _set_flip()
  _move_and_slide(delta)
  
  if is_on_floor():
    _enter_state(STATE_MACHINE.IDLE)
