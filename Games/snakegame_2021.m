function snakegame
%SNAKEGAME is a game of snake
%
% 2021, Alexander Heimel

global alive snake

arena = create_arena();
snake = create_snake();

alive = true;

fps = 20; % Hz

while alive
    show_arena( arena, snake );
    snake = movesnake( snake );
    if hit_wall(arena,snake)
        alive = false;
    end
    pause( 1/fps);
end

text(15,15,'GAME OVER', 'HorizontalAlignment','center','COlor',[1 1 1])

disp('GAMEOVER');

function hit = hit_wall(arena,snake)

if arena(snake.head.y,snake.head.x) ~= 0
    hit = true;
else
    hit = false;
end


function show_arena(arena,snake)

world = arena;
world(snake.head.y,snake.head.x) = 64;
image(world)

function snake = movesnake( snake )
snake.head.x = snake.head.x + snake.dx;
snake.head.y = snake.head.y + snake.dy;



function arena = create_arena()
arena = zeros(30,30,'uint8');
arena(1,:) = 255;
arena(end,:) = 255;
arena(:,1) = 255;
arena(:,end) = 255;

figure(1)
set(gcf,'WindowKeyPressFcn',@keypress)

function keypress(src,event)
global alive snake
switch event.Key
    case 'q'
        alive = false;
    case 'leftarrow'
        tempdy = snake.dy;
        snake.dy = -snake.dx;
        snake.dx = tempdy;
    case 'rightarrow'
        tempdy = snake.dy;
        snake.dy = snake.dx;
        snake.dx = -tempdy;
        
end

function snake = create_snake()
snake.head.x = 15;
snake.head.y = 15;
snake.dx = 1;
snake.dy = 0;
snake.tail = [];

