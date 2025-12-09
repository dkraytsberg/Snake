
if _room == ROOM_GAME {
    if dead or jormungar {
        if _esc_enter_space() or keyboard_check_pressed(ord("R")) { 
            game_init();
            return;
        } 
        if keyboard_check_pressed(ord("Q")) { game_restart() }
        
    }
    
    if paused and keyboard_check_pressed(ord("Q")) { game_restart() }
   
    if (not dead and not jormungar) and _esc_enter_space() { 
        paused = !paused
    }
   
   if not paused {
       _movement_keyboard_checks()
       _check_collision_move_snake()
       
       if state_is_powerup() {
           if powerup_counter <= 1 {
               reset_snake_mode()
           } else {
               powerup_counter -= 1;
           }     
       }
       
       if state_is_frenzy() {
           if frenzy_counter <= 1 {
               food = []
               make_food()
               reset_snake_mode()
          } else {
               frenzy_counter -= 1
          }
       }
   }
}

if _room == ROOM_MENU {
    if keyboard_check_pressed(vk_enter) {
        _room = ROOM_GAME
        game_init()
    }
    else if keyboard_check_pressed(ord("M")) {
        _room = ROOM_MODE_SELECT
    }
    else if keyboard_check_pressed(ord("I")) {
        _room = ROOM_INFO
    }
}

if _room == ROOM_MODE_SELECT {
    if keyboard_check_pressed(vk_escape) {
        _room = ROOM_MENU
    }
    
    if keyboard_check_pressed(vk_enter) or keyboard_check_pressed(vk_space) {
        _room = ROOM_GAME
    }
    
    if keyboard_check_pressed(ord("T")) {
        // turbo
        mode_turbo = !mode_turbo
    }
    
    if keyboard_check_pressed(ord("P")) {
        // pure
        mode_pure = !mode_pure
    }
}

if _room == ROOM_INFO {
    if keyboard_check_pressed(vk_escape) {
        _room = ROOM_MENU
    }
}