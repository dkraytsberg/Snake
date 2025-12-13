
if _room == ROOM_GAME {
    if dead or jormungar {
        if _esc_enter_space() or keyboard_check_pressed(ord("R")) { 
            highscore_add("snake", score)
            game_init();
            return;
        } 
        if keyboard_check_pressed(ord("Q")) { game_init(); _room = ROOM_MENU; highscore_add("snake", score); return }
        
    }
    
    if paused and keyboard_check_pressed(ord("Q")) { game_init(); _room = ROOM_MENU; highscore_add("snake", score); return }
   
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
               food = [] // TODO: this kills the other food in multi_mode
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
        return
    }
    else if keyboard_check_pressed(ord("I")) {
        _room = ROOM_INFO
        return
    }
    else if keyboard_check_pressed(ord("Q")) {
        game_end()
    }
    else if keyboard_check_pressed(ord("C")) {
        highscore_clear()
    }
    else if keyboard_check_pressed(ord("H")) {
        _room = ROOM_HIGHSCORE
        return
    }
}

if _room == ROOM_MODE_SELECT {
    if keyboard_check_pressed(vk_escape) { _room = ROOM_MENU; return; }
    if keyboard_check_pressed(vk_enter) or keyboard_check_pressed(vk_space) { _room = ROOM_GAME; return; }
    if keyboard_check_pressed(ord("T")) { mode_turbo = !mode_turbo; }
    if keyboard_check_pressed(ord("P")) { mode_pure = !mode_pure; mode_rush = false; mode_multi = false; }
    if keyboard_check_pressed(ord("R")) { mode_rush = !mode_rush; mode_pure = false; }
    if keyboard_check_pressed(ord("M")) { mode_multi = !mode_multi; }
}

if _room == ROOM_INFO {
    if keyboard_check_pressed(vk_escape) {
        _room = ROOM_MENU
    }
}

if _room == ROOM_HIGHSCORE {
    if keyboard_check_pressed(vk_escape) {
        _room = ROOM_MENU
    }
}