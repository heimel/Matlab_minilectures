function snake
%SNAKE game
%
% 2019, Alexander Heimel

NORTH = 1;
EAST = 2;
SOUTH = 3;
WEST = 4;

width = 50;
height = 30;

arena = zeros(height,width);

global Direction

h_arena = figure('Name','Snake','NumberTitle','off');

n_food = 6;
for i=1:n_food
    arena = place_food(arena);
end

show_arena(arena);

set(h_arena,'WindowKeyPressFcn',@keypress)

headc = ceil(width/2);
headr = ceil(height/2);
tailr = [];
tailc = [];
Direction = EAST;

dead = false;
while ~dead
    
    tailr = [headr tailr];
    tailc = [headc tailc];

    switch Direction
        case NORTH
            headr = headr + 1;
            if headr>height
                headr = 1;
            end
        case EAST
            headc = headc + 1;
            if headc>width
                headc = 1;
            end
        case SOUTH
            headr = headr - 1;
            if headr<1
                headr = height;
            end
        case WEST
            headc = headc - 1;
            if headc < 1
                headc = width;
            end
    end
    
    if arena(headr,headc) == FOOD
        arena = place_food(arena);
    elseif arena(headr,headc) == SNAKE
        dead = true;
    else
        % move tail
        arena(tailr(end),tailc(end)) = 0;
        tailr(end) = [];
        tailc(end) = [];
    end
    
    
    arena(headr,headc) = SNAKE;
    show_arena(arena);
    
     
    pause(0.03);
end
disp('YOU DIED');


function show_arena(arena)

image(arena);
axis image off 
drawnow;

function keypress(src,event)

global Direction
switch event.Key
    case 'rightarrow'
        Direction = Direction+1;
        if Direction>4
            Direction = 1;
        end
    case 'leftarrow'
        Direction = Direction - 1;
        if Direction<1
            Direction = 4;
        end
end        

function arena = place_food(arena)

empty_spot = false;
while ~empty_spot
    r = randi(size(arena,1));
    c = randi(size(arena,2));
    
    if arena(r,c)==0
        empty_spot = true;
    end
end
arena(r,c) = FOOD;

function v = FOOD 
v = 32;

function v = SNAKE
v = 64;