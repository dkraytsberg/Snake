
if keyboard_check_pressed(vk_right) and dir[0] != -1 {
    dir = [1,0]
} 
else if keyboard_check_pressed(vk_left) and dir[0] != 1  {
    dir = [-1,0]
} 
else if keyboard_check_pressed(vk_up) and dir[1] != 1 {
    dir = [0,-1]
} 
else if keyboard_check_pressed(vk_down) and dir[1] != -1 {
    dir = [0,1]
} 

if (dead or jormungar) and keyboard_check_pressed(vk_enter) {
    game_restart()
}

if keyboard_check_pressed(vk_escape) and not dead and not jormungar {
    paused = !paused
}

if not paused {
    if speed_counter <= 0 { 
       check_collision()
   
       if not dead and not jormungar { 
           move_snake()
       }
       speed_counter = BASE_SPEED_COUNTER;
   } else {
       speed_counter -= 1
   }
    
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


