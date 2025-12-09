draw_set_font(snake_font)
draw_set_halign(fa_left);
draw_set_valign(fa_top); 


if _room == ROOM_GAME {
    draw_set_colour(color)
    draw_rectangle(border, border_top, room_width - border, room_height - border, true)
   
    if not paused {
        // Draw Snake
        for(var i = 0; i < array_length(snakes); i++) {
           var s = snakes[i]
           var snake_x = s[0] * snake_size + border;
           var snake_y = s[1] * snake_size + border_top;
           draw_set_colour(food_to_snake_color(s[2]))
           var is_outline = s[2] == FOOD_GHOST
           draw_rectangle(snake_x, snake_y, snake_x + snake_size, snake_y + snake_size, is_outline)
       }
       
       // Draw Food
       for (var i = 0; i < array_length(food); i++) { 
           var f = food[i]
           var foodxy = [f[0] * food_size + border, f[1] * food_size + border_top]
           draw_set_colour(food_to_color(f[2]))
           var is_outline = f[2] == FOOD_GHOST or f[2] == FOOD_FEAST
           draw_rectangle(foodxy[0], foodxy[1], foodxy[0] + food_size, foodxy[1] + food_size, is_outline)
       }
    }
   
    draw_set_colour(color)
    draw_text(border, 16, "SCORE: " + string(score));
   
    if jormungar {
        print_text("Jormungandr " + string(score_before_jormungar))
    } else if dead {
        print_text("DEAD! [R] TO RESTART [Q] TO EXIT")
    } else if paused {
        print_text("--PAUSED--")
        draw_set_halign(fa_center);
        draw_text(room_width / 2, room_height / 2, "PRESS [enter] TO CONTINUE")
        draw_text(room_width / 2, room_height / 2 + 20, "PRESS [Q] TO QUIT")
        draw_set_halign(fa_left);
    } else if frenzy_counter > 0 {
        var frenzy_digit = ceil(frenzy_counter / game_get_speed(gamespeed_fps))
        print_text("FRENZY! " + string(frenzy_digit), color)
    } else if snake_food_mode == FOOD_FEAST_SUCCESS {
        print_text("SUCCESS!")
    }
}

if _room == ROOM_MENU {
    draw_rectangle(border, border_top, room_width - border, room_height - border, true)
    
    draw_set_colour(c_white)
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_font(snake_font_large)
    draw_text(room_width / 2, room_height / 2 - 32, "SNAKE")
    draw_set_font(snake_font)
    draw_text(room_width / 2, room_height / 2 + 32, "PRESS [enter] TO START")
    draw_text(room_width / 2, room_height / 2 + 50, "[M] MODE SELECT")
    draw_text(room_width / 2, room_height / 2 + 68, "[I] INFO")
}

if _room == ROOM_MODE_SELECT { 
    draw_set_colour(c_white)
    draw_rectangle(border, border_top, room_width - border, room_height - border, true)
    draw_set_halign(fa_center);
    var pure_mode_text = "OFF"; if mode_pure then pure_mode_text = "ON ";
    var turbo_mode_text = "OFF"; if mode_turbo then turbo_mode_text = "ON ";
    if mode_pure then pure_mode_text = "ON "
    draw_text(room_width / 2, room_height / 2 - 64, "[P] PURE MODE  " + pure_mode_text)
    draw_text(room_width / 2, room_height / 2 - 46, "[T] TURBO!     " + turbo_mode_text)
    draw_text(room_width / 2, room_height / 2 - 10, "PRESS [enter] TO START")
    draw_text(room_width / 2, room_height - (border * 2), "PRESS [ESC] TO GO BACK")
}

if _room == ROOM_INFO {
    draw_set_colour(c_white)
    draw_rectangle(border, border_top, room_width - border, room_height - border, true)
    draw_set_halign(fa_center);
    draw_text(room_width / 2, room_height - (border * 2), "PRESS [ESC] TO GO BACK")
    
    var foods = [ FOOD_NORMAL, FOOD_SUPER, FOOD_LONG, FOOD_GHOST, FOOD_FRENZY, FOOD_FEAST ]
    
    for (var i = 0; i < array_length(foods); i++) {
        draw_set_colour(food_to_color(foods[i]))
        var fx = border + (room_width / 10)
        var fy = border_top + (room_width / 10) + (food_size * i * 3)
        var fx2 = fx + (food_size * 2)
        var fy2 = fy + (food_size * 2)
        var is_outline = foods[i] == FOOD_GHOST or foods[i] == FOOD_FEAST
        draw_rectangle(fx, fy, fx2, fy2, is_outline)
        draw_set_halign(fa_left);
        draw_text(fx2 + food_size, fy, food_to_info(foods[i]))
    }
}



