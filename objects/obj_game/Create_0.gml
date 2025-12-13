#macro ROOM_MENU "menu"
#macro ROOM_GAME "game"
#macro ROOM_MODE_SELECT "settings"
#macro ROOM_INFO "info"
#macro ROOM_HIGHSCORE "highscore"
#macro ROOM_SCRATCH "scratch"
_room = ROOM_MENU

#macro border 32
#macro border_top 64
#macro snake_size 8
#macro food_size snake_size
#macro font_size_line_height 18
#macro hor_squares ((room_width - border - border) / snake_size)
#macro ver_squares ((room_height - border - border_top) / snake_size)


BASE_SPEED_COUNTER = 4
TURBO_SPEED_COUNTER = 2
BASE_POWERUP_COUNTER = 3 * game_get_speed(gamespeed_fps)
BASE_FRENZY_COUNTER = 6 * game_get_speed(gamespeed_fps)

speed_counter = 0
powerup_counter = 0
frenzy_counter = 0

mode_turbo = false
mode_pure = false
mode_rush = false
mode_multi = false

#macro FOOD_NORMAL "normal"
#macro FOOD_SUPER "super"
#macro FOOD_LONG "long"
#macro FOOD_GHOST "ghost"
#macro FOOD_FRENZY "frenzy"
#macro FOOD_FEAST "feast"
#macro FOOD_FEAST_SUCCESS "feast_success"
#macro FOOD_FEAST_FAILED "feast_failed"
#macro FOOD_DEAD "dead"

_food_options = [FOOD_SUPER, FOOD_LONG, FOOD_GHOST, FOOD_FRENZY]
_STARTING_SNAKES = [[0,0, FOOD_NORMAL], [0, 1, FOOD_NORMAL], [1,1, FOOD_NORMAL], [2,1, FOOD_NORMAL], [3,1, FOOD_NORMAL], [4,1,FOOD_NORMAL]]

function game_init() {
    snakes = []
    array_copy(snakes, 0, _STARTING_SNAKES, 0, 6)
    food = []
    score = 0
    foods_eaten = 0
    dir = [1, 0]
    score_before_jormungar = 0
    dead = false
    show_new_highscore = false
    jormungar = false
    paused = false
    speed_counter = 0
    _input_buffer = [1, 0]
    reset_snake_mode()
    make_food(FOOD_NORMAL)
}

function reset_snake_mode() {
    snake_food_mode = FOOD_NORMAL;
    color = c_yellow;
    frenzy_counter = 0;
    powerup_counter = 0;
}

function food_to_color(f) {
    switch(f){
        case FOOD_NORMAL: return c_white
        case FOOD_SUPER: return c_fuchsia
        case FOOD_LONG: return c_aqua
        case FOOD_GHOST: return c_silver
        case FOOD_FRENZY: return c_red
        case FOOD_FEAST: return c_red
        case FOOD_FEAST_SUCCESS: return c_yellow
        case FOOD_FEAST_FAILED: return c_yellow
        case FOOD_DEAD: return c_white 
    }
}

function food_to_info(f) {
    switch(f){
        case FOOD_NORMAL: return "Regular food, delicious!"
        case FOOD_SUPER: return "Super Food, double your score!"
        case FOOD_LONG: return "Long Food, become longer!" 
        case FOOD_GHOST: return "Ghost Food??"
        case FOOD_FRENZY: return "Frenzy Food!!!"
        case FOOD_FEAST: return "Feast Food! Eat quickly for a bonus!"
    }
}

function food_to_snake_color(f) {
    if f == FOOD_NORMAL {
        return c_yellow
    }
    return food_to_color(f)
}

function state_is_powerup() {
    return snake_food_mode == FOOD_GHOST or snake_food_mode == FOOD_LONG;
}

function state_is_frenzy() {
    return snake_food_mode == FOOD_FRENZY or snake_food_mode == FOOD_FEAST;
}

// todo: delete
function print_text(text, col = c_white) {
    draw_set_colour(c_white)
    draw_set_halign(fa_center);
    draw_text(room_width / 2, 16, text)
    draw_set_halign(fa_left);
}


function make_food(type) {
    var food_type = FOOD_NORMAL
    
    if type != undefined {
        food_type = type
    } else {
        if mode_rush {
            food_type = _food_options[irandom(array_length(_food_options) - 1)]
        }
        else if not mode_pure and random(10) >= 7 and score > 10 {
            food_type = _food_options[irandom(array_length(_food_options) - 1)]
        }
    }
    
    array_push(food, [
        irandom_range(1, hor_squares - 2), 
        irandom_range(1, ver_squares - 2), 
        food_type
    ])
}

function process_food_effects() {
    if mode_turbo {
        score += 4
    }
    if snake_food_mode == FOOD_SUPER {
        score *= 2
    } else if snake_food_mode == FOOD_GHOST {
        powerup_counter = BASE_POWERUP_COUNTER
    } else if snake_food_mode == FOOD_LONG {
        powerup_counter = BASE_POWERUP_COUNTER
    } else if snake_food_mode == FOOD_FRENZY {
        repeat(irandom_range(4, 6)) {
            make_food(FOOD_FEAST)
        }
        frenzy_counter = BASE_FRENZY_COUNTER
    } else if snake_food_mode == FOOD_FEAST {
        frenzy_counter += game_get_speed(gamespeed_fps)
    }
    
    color = food_to_snake_color(snake_food_mode)
}

function check_food_eaten() {
    for(var i = 0; i < array_length(food); i++) {
        var food_collision = head[0] == food[i][0] and head[1] == food[i][1];
        if food_collision {
            color = c_yellow;
            score += 1
            foods_eaten += 1
            snake_food_mode = food[i][2]
            /*
            var game_sped = game_get_speed(gamespeed_fps)
            game_set_speed(game_sped + 5, gamespeed_fps)
            */
            process_food_effects()
            array_delete(food, i, 1)
           
            // TODO: check that there are no more feast foods in the array, to account for multi-mode
            if array_length(food) == 0 {
                if frenzy_counter > 0 {
                   // feast successful
                   snake_food_mode = FOOD_FEAST_SUCCESS //FOOD_NORMAL
                   score *= 3
                   frenzy_counter = 0 
                   color = food_to_color(FOOD_FEAST_SUCCESS)
               } 
               make_food()
                
                if mode_multi {
                    repeat(irandom_range(1, 3)) {
                        make_food()
                    }
                }
           }
           return true;
       }
    }
    
    return false;
}

function move_snake() {
    head = array_last(snakes)
    
    dir = _input_buffer
    
    var new_head = [
        (head[0] + dir[0] + hor_squares) % hor_squares, 
        (head[1] + dir[1] + ver_squares) % ver_squares,
        snake_food_mode
    ]
    
    array_push(snakes, new_head)
    
    if snake_food_mode == FOOD_LONG {
        score += 1;
    }
    
    var ate_food = check_food_eaten()
    
    if !ate_food and snake_food_mode != FOOD_LONG { 
        array_shift(snakes)
    }
}

function set_all_snakes_to(food_type) {
  array_foreach(snakes, function(s, i) { s[2] = food_type; });
}

function check_collision() {
    var head = array_last(snakes)
    var tail = array_first(snakes)
    
    if head[0] == tail[0] and head[1] == tail[1] {
        if not jormungar { 
            score_before_jormungar = score * 100
            array_foreach(snakes, function(s, i) { s[2] = FOOD_DEAD });
        }
        jormungar = true
        score *= 100;
        highscore_add("jormungandr", score)
        return
    }
    for(var i = 0; i < array_length(snakes) - 1; i++) {
        if head[0] == snakes[i][0] and head[1] == snakes[i][1] { 
            if snake_food_mode != FOOD_GHOST and snakes[i][2] != FOOD_GHOST {
                reset_snake_mode();
                array_foreach(snakes, function(s, i) { s[2] = FOOD_DEAD });
                food = []; color = c_white; dead = true;
                if score > highscore_value(1) {
                    show_new_highscore = true
                }
                highscore_add("snake", score)
                return;
            } else {
                score += 5;
            }
        }
    }
}

function _movement_keyboard_checks() {
    if keyboard_check_pressed(vk_right) and dir[0] != -1 {
        _input_buffer = [1,0]
    } 
    else if keyboard_check_pressed(vk_left) and dir[0] != 1  {
        _input_buffer = [-1,0]
    } 
    else if keyboard_check_pressed(vk_up) and dir[1] != 1 {
        _input_buffer = [0,-1]
    } 
    else if keyboard_check_pressed(vk_down) and dir[1] != -1 {
        _input_buffer = [0,1]
    }
}

function _check_collision_move_snake() { 
    if speed_counter <= 0 { 
        if not dead and not jormungar {
            move_snake()
            check_collision()
            if mode_turbo { 
                speed_counter = TURBO_SPEED_COUNTER;
            } else {
                speed_counter = BASE_SPEED_COUNTER;
            }
        }
    } else {
        speed_counter -= 1
    }
}

function _esc_enter_space() {
    return keyboard_check_pressed(vk_escape) or keyboard_check_pressed(vk_enter) or keyboard_check_pressed(vk_space)
}

game_init()