extends CharacterBase


func _process(delta: float) -> void:
  match state:
    STATE_MACHINE.IDLE: _state_idle(delta)
    STATE_MACHINE.WALK: _state_walk(delta)
    STATE_MACHINE.JUMP: _state_jump(delta)


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
    _enter_state(STATE_MACHINE.JUMP)


func _state_jump(delta: float) -> void:
  _set_animation('jump')
  _apply_gravity(delta)
  
  if enter_state:
    enter_state = false
    motion.y = -jump_force
    
  if motion.y > 0:
    _enter_state(STATE_MACHINE.IDLE)
