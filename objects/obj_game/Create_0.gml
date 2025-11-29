border = 32;
border_top = 64;
snake_size = 8;
food_size = 8;
hor_squares = (room_width - border - border) / 8
ver_squares = (room_height - border - border_top) / 8

dead = false
jormungar = false
BASE_SPEED_COUNTER = 2
BASE_POWERUP_COUNTER = game_get_speed(gamespeed_fps) / BASE_SPEED_COUNTER
speed_counter = BASE_SPEED_COUNTER
powerup_counter = 0
paused = false

FOOD_NORMAL = "normal"
FOOD_SUPER = "super"
FOOD_LONG = "long"
FOOD_GHOST = "ghost"

snake_food_mode = FOOD_NORMAL

color = c_yellow
dir = [1, 0]
snakes = [[0,0, color], [0, 1, color], [1,1, color], [2,1, color], [3,1, color], [4,1,color]]
food = [4, 4, FOOD_NORMAL]

score = 0

// audio_play_sound(vibe, 1, true)

function get_food_xy() {
    return [food[0] * food_size + border, food[1] * food_size + border_top]
}

function make_food() { 
    var food_type = FOOD_NORMAL
    
    if random(9) >= 6 {
        food_type = choose(FOOD_SUPER, FOOD_LONG, FOOD_GHOST)
    }
    
    food = [irandom_range(0, hor_squares - 1), irandom_range(0, ver_squares - 1), food_type]

}

function move_snake() {
    head = array_last(snakes)
    
    var new_head = [
        (head[0] + dir[0] + hor_squares) % hor_squares, 
        (head[1] + dir[1] + ver_squares) % ver_squares,
        color
    ]
    
    array_push(snakes, new_head)
    
    if powerup_counter <= 0 and (snake_food_mode == FOOD_GHOST or snake_food_mode == FOOD_LONG) {
        snake_food_mode = FOOD_NORMAL;
        color = c_yellow
    } else {
        powerup_counter -= 1;
    }
    
    if snake_food_mode == FOOD_LONG {
        score += 1;
    }
    
    if head[0] == food[0] and head[1] == food[1] {
        color = c_yellow
        score += 1
        snake_food_mode = food[2]
        
        if snake_food_mode == FOOD_SUPER {
            score *= 2
            color = c_fuchsia
        } else if snake_food_mode == FOOD_GHOST {
            color = c_silver
            powerup_counter = BASE_POWERUP_COUNTER
        } else if snake_food_mode == FOOD_LONG {
            color = c_aqua
            powerup_counter = BASE_POWERUP_COUNTER
        }
        
        make_food()
        

    } else {
        if snake_food_mode != FOOD_LONG { 
            array_shift(snakes)
        }
    }
}

function check_collision() {
    head = array_last(snakes)
    tail = array_first(snakes)
    
    if head[0] == tail[0] and head[1] == tail[1] {
        jormungar = true
        return
    }
    for(var i = 0; i < array_length(snakes) - 1; i++) {
        if head[0] == snakes[i][0] and head[1] == snakes[i][1] { 
            if snake_food_mode != FOOD_GHOST and snakes[i][2] != c_silver {
               dead = true;
               return
            } else {
                score += 5;
            }
        }
    }
}