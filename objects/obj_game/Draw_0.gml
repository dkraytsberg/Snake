function _draw_border() {
    draw_rectangle(border, border_top, room_width - border, room_height - border, true)
}

function __draw_top_text(text, hindex, vindex, pad = 0) {
    var halign; var tx;
    if hindex <= 0 { 
        halign = fa_left 
        tx = border
    } else if hindex == 1 { 
        halign = fa_center
        tx = room_width / 2
    } else if hindex >= 2 { 
        halign = fa_right
        tx = room_width - border
    }
    
    var prev_halign = draw_get_halign()
    draw_set_halign(halign)
    draw_text(tx, pad + 8 + vindex * font_size_line_height, text)
    draw_set_halign(prev_halign)
}

function __draw_body_text(text, hindex, vindex) {
    __draw_top_text(text, hindex, vindex, border_top)
}

function _draw_center_text(text, vindex) {
    __draw_top_text(text, 1, vindex, border_top)
}

function _draw_score(scr) {
    __draw_top_text(scr, 0, 0)
}

function _draw_status(status) {
    __draw_top_text(status, 1, 1)
}

function _draw_mode(mode) {
    __draw_top_text(mode, 2, 0)
}

function _draw_highscore(scr) {
    __draw_top_text(scr, 2, 2)
}

draw_set_font(snake_font)
draw_set_halign(fa_left);
draw_set_valign(fa_top); 
draw_set_colour(c_white)


//_draw_highscore("HIGHSCORE: " + string(highscore_value(1)))

if _room == ROOM_GAME {
    draw_set_colour(color)
    _draw_border()
   
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
    _draw_score("SCORE: " + string(score))
    
    if score > highscore_value(1) {
        _draw_highscore("NEW HIGH SCORE!")
    }
   
    if jormungar {
        _draw_status("Jormungandr " + string(score_before_jormungar))
    } else if dead {
        _draw_status("DEAD! [R] TO RESTART [Q] TO EXIT")
    } else if paused {
        draw_set_color(c_white)
        _draw_status("--PAUSED--")
        draw_set_halign(fa_center);
        draw_text(room_width / 2, room_height / 2, "PRESS [enter] TO CONTINUE")
        draw_text(room_width / 2, room_height / 2 + 20, "PRESS [Q] TO QUIT")
        draw_set_halign(fa_left);
        draw_set_color(color)
    } else if frenzy_counter > 0 {
        var frenzy_digit = ceil(frenzy_counter / game_get_speed(gamespeed_fps))
        //draw_set_colour(color)
        _draw_status("FRENZY! " + string(frenzy_digit))
        //draw_set_colour(c_white)
    } else if snake_food_mode == FOOD_FEAST_SUCCESS {
        _draw_status("SUCCESS!")
    } else if snake_food_mode == FOOD_GHOST {
        _draw_status("GHOST MODE")
    }
    
    var mode_str = ""
    if mode_pure { mode_str += " PURE" } 
    if mode_multi { mode_str += " MULTI!" }
    if mode_turbo { mode_str += " TURBO!" } 
    if mode_rush { mode_str += " RUSH!" }
    if mode_str != "" { _draw_mode(mode_str) }

}

if _room == ROOM_MENU {
    _draw_border()
    
    draw_set_colour(c_white)
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_font(snake_font_large)
    draw_text(room_width / 2, room_height / 2 - 32, "SNAKE")
    draw_set_font(snake_font)
    draw_text(room_width / 2, room_height / 2 + 32, "PRESS [enter] TO START")
    draw_text(room_width / 2, room_height / 2 + 50, "[M] MODE SELECT")
    draw_text(room_width / 2, room_height / 2 + 68, "[I] INFO")
    draw_text(room_width / 2, room_height / 2 + 86, "[H] HIGHSCORES")
}

if _room == ROOM_MODE_SELECT {
    draw_set_colour(c_white)
    _draw_border()
    draw_set_halign(fa_center);
    var pure_mode_text = "OFF"; if mode_pure then pure_mode_text = "ON ";
    var turbo_mode_text = "OFF"; if mode_turbo then turbo_mode_text = "ON ";
    var rush_mode_text = "OFF"; if mode_rush then rush_mode_text = "ON ";
    var multi_mode_text = "OFF"; if mode_multi then multi_mode_text = "ON ";

    draw_text(room_width / 2, room_height / 2 - 64, "[P]  PURE MODE  " + pure_mode_text)
    draw_text(room_width / 2, room_height / 2 - 46, "[T]  TURBO!     " + turbo_mode_text)
    draw_text(room_width / 2, room_height / 2 - 28, "[R]  POWER RUSH " + rush_mode_text)
    draw_text(room_width / 2, room_height / 2 - 10, "[M]  MULTI-FOOD " + multi_mode_text)
    draw_text(room_width / 2, room_height / 2 + 18, "PRESS [enter] TO START")
    draw_text(room_width / 2, room_height - (border * 2), "PRESS [ESC] TO GO BACK")
}

if _room == ROOM_INFO {
    draw_set_colour(c_white)
    _draw_border()
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


if _room == ROOM_SCRATCH {
    _draw_border()
    _draw_score("SCORE: 1231231")
    _draw_status("--PAUSED--")
    _draw_mode("TURBO!")
}

if _room == ROOM_HIGHSCORE {
    _draw_border()
    draw_set_halign(fa_center);
    draw_text(room_width / 2, room_height - (border * 2), "PRESS [ESC] TO GO BACK")
    _draw_center_text(highscore_value(1), 5)
    _draw_center_text(highscore_value(2), 6)
    _draw_center_text(highscore_value(3), 7)
}


