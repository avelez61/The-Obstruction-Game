-- Programmer: u/avelez6
--[[
    OBSTRUCTION:
    Obstruction pencil and paper game written in Lua with love2d. Obstruction 
    is a game where players take turns marking empty cells on a grid. Everytime a 
    player marks a cell, the neighbors cells are also marked as blocked. Once 
    the grid fills up the player that cannot make a move loses.
    
    For this project I implemented the game with Lua and love2d but also implemented
    a computer player that uses the minimax algorithm with alpha-beta pruning to 
    find the best moves. The project tested my skill with a new language, a new 
    framework, and a popular algorithm that I plan to use for future games.
--]]
-- Credit to u/xemeds on Reddit for this project's inspiration

local EMPTY, O_MARKER, X_MARKER, BLOCK_MARKER = 0, 1, 2, 3
local O_TURN, X_TURN = 1, 2
local NO_WIN, O_WIN, X_WIN = 0, 1, -1
local ROWS, COLS, CELL_WIDTH, CELL_HEIGHT = 6, 6, 64, 64
local MAX_EVAL, MIN_EVAL = 2, -2

function love.load()
    love.window.setTitle("OBSTRUCTION")
    love.window.setMode(CELL_WIDTH * COLS, CELL_HEIGHT * ROWS)
    key_press_char, key_released, mouse_released = nil, false, false

    cell_image = love.graphics.newImage("assets/cell.png")
    x_marker_image = love.graphics.newImage("assets/x_marker.png")
    o_marker_image = love.graphics.newImage("assets/o_marker.png")
    block_marker_image = love.graphics.newImage("assets/block_marker.png")

    grid, turn, is_game_over = create_new_game()
    cpu_player = X_TURN
end

function love.update(dt)
    if key_released then
        if key_press_char == "escape" then
            love.event.quit()
        elseif key_press_char == "n" then
            grid, turn, is_game_over = create_new_game()
        elseif key_press_char == "1" then
            cpu_player = turn
        elseif key_press_char == "2" then
            cpu_player = nil
        end

        key_released = false
        key_press_char = nil
    
    elseif is_game_over == NO_WIN then
        if mouse_released and turn ~= cpu_player then
            local row = math.floor(love.mouse.getY() / CELL_HEIGHT) + 1
            local col = math.floor(love.mouse.getX() / CELL_WIDTH) + 1
            
            if grid[row][col] == EMPTY then
                place_marker(grid, turn, row, col)
                is_game_over = check_game_over(grid, turn)
                turn = switch_turn(turn)
            end

            mouse_released = false

        elseif turn == cpu_player then
            local is_maximizer = (turn == O_TURN and true or false)
            local row, col = minimax(grid, turn, 0, MIN_EVAL, MAX_EVAL, is_maximizer)

            place_marker(grid, turn, row, col)
            is_game_over = check_game_over(grid, turn)
            turn = switch_turn(turn)
        end
    end
end

function love.draw()
    for r = 0, ROWS - 1 do
        for c = 0, COLS - 1 do
            local x, y = c * CELL_WIDTH, r * CELL_HEIGHT

            love.graphics.draw(cell_image, x, y)
            if grid[r + 1][c + 1] == O_MARKER then
                love.graphics.draw(o_marker_image, x, y)
            elseif grid[r + 1][c + 1] == X_MARKER then
                love.graphics.draw(x_marker_image, x, y)
            elseif grid[r + 1][c + 1] == BLOCK_MARKER then
                love.graphics.draw(block_marker_image, x, y)
            end
        end
    end
end

function love.mousereleased()
    mouse_released = true
end

function love.keyreleased(key)
    key_released = true
    key_press_char = key
end

-- Creates a new matrix, sets the current turn, sets the win state, and 
-- returns all variables to create a new game
function create_new_game()
    local grid = {}
    for r = 1, ROWS do
        grid[r] = {}
        for c = 1, COLS do 
            grid[r][c] = EMPTY
        end
    end
    local turn = O_TURN

    return grid, turn, NO_WIN
end

-- Places marker on non-nil 2d array, grid. Marker type is determined by turn.
-- row and col are valid  positive integers less than ROWS and COLS repspectivley
-- for marker placement on grid.
function place_marker(grid, turn, row, col)
    local player_marker = (turn == O_TURN and O_MARKER or X_MARKER)
    grid[row][col] = player_marker

    -- credit to u/btwiusearch for sharing the below code to u/xemeds
    -- Specifically the code will find the neighbor cells of grid[row][col]
    -- using min and max functions to keep r and c values in bounds
    for r = math.max(row - 1, 1), math.min(row + 1, ROWS) do
        for c = math.max(col - 1, 1), math.min(col + 1, COLS) do
            if r ~= row or c ~= col then 
                grid[r][c] = BLOCK_MARKER
            end
        end
    end
end

-- Uses current grid state and returns NO_WIN if an EMPTY value is found on the grid.
-- Otherwise returns O_WIN if turn is X_TURN and X_WIN if turn is O_TURN.
function check_game_over(grid, turn)
    for _,row in ipairs(grid) do
        for _,cell in ipairs(row)  do
            if cell == EMPTY then return NO_WIN end
        end
    end

    return turn == O_TURN and X_WIN or O_WIN
end

-- Returns O_TURN if turn is X_TURN or X_TURN if turn is O_TURN
function switch_turn(turn)
    return turn == O_TURN and X_TURN or O_TURN
end

-- Uses makes a copy of the non-nil old_matrix and returns a reference to it.
function deep_copy_matrix(old_matrix)
    local new_matrix = {}

    for r,row in ipairs(old_matrix) do
        new_matrix[r] = {}
        for c,cell in ipairs(row) do
            new_matrix[r][c] = cell
        end
    end

    return new_matrix
end

-- Uses the current grid state to ultimatley choose the best move possible.
-- The depth determines the return type, is_maximizer determines who the algorithm
-- is finding the best move for (maximizer = O player, minimizer = X player). alpha
-- beta pruning technique is also used and requries the respective parameters.
-- Returns the row and column coordinates for the best move if the depth is 
-- 0. Returns an integer evaluation score of the end state if the depth is not 0.
function minimax(grid, turn, depth, alpha, beta, is_maximizer)
    local end_state = check_game_over(grid, turn)
    if end_state ~= NO_WIN then
        return end_state
    end

    local best_move, best_evaluation

    if is_maximizer then
        best_evaluation = MIN_EVAL
    else
        best_evaluation = MAX_EVAL
    end

    for r,row in ipairs(grid) do
        for c,cell in ipairs(row) do
            if cell == EMPTY then
                local new_grid = deep_copy_matrix(grid)
                place_marker(new_grid, turn, r, c)
                local new_turn = switch_turn(turn)

                local evaluation = minimax(new_grid, new_turn, depth + 1, alpha, beta, not is_maximizer)
                if is_maximizer and evaluation > best_evaluation then
                    best_evaluation = evaluation
                    best_move = {r, c}
                    
                    alpha = math.max(alpha, evaluation)
                    if alpha >= beta then goto break_label end
                elseif not is_maximizer and evaluation < best_evaluation then
                    best_evaluation = evaluation
                    best_move = {r, c}

                    beta = math.min(beta, evaluation)
                    if beta <= alpha then goto break_label end
                end
            end            
        end
    end

    ::break_label::

    if depth == 0 then
        return unpack(best_move)
    else
        return best_evaluation
    end
end
