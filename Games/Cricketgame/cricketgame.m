%CRICKETGAME a catch the escaping cricket game
%
% 2020, Alexander Heimel
global arena cricket mouse

close all
arena = ones(800,800,3,'uint8') * 255;
fig = figure('keypressfcn',@keypressfunction,'windowstyle','modal');
camera = arena;
image(camera);
axis equal off xy;
disableDefaultInteractivity(gca);

cricket.orgimage = 255-imread('cricket.jpg');
cricket.position = [300 300];
cricket.speed = 200; % pixels per s.
set_cricket_target();

mouse.orgimage = 255 - imread('mouse.jpg');
mouse.position = [500 500];
mouse.speed = 0; % pixels per s
mouse.direction = 0; % deg

global t
global frameperiod
frameperiod = 0.05; %s
t = timer('Period',frameperiod,'ExecutionMode','fixedRate','TimerFcn',{@update_frame});
start(t);

function keypressfunction(~,keydata)
global mouse t
switch keydata.Key
    case 'uparrow'
        mouse.speed = 200;
    case 'downarrow'
        mouse.speed = -200;
    case 'rightarrow'
        mouse.direction = mouse.direction - 10;
    case 'leftarrow'
        mouse.direction = mouse.direction + 10;
    case 'q'
        stop(t);
        delete(t);    
        set(gcf,'WindowStyle','normal');
        disp('The end');
end

end

function set_cricket_target()
global arena cricket
cricket.target(1) = randi( size(arena,1)-2*size(cricket.orgimage,1)) + size(cricket.orgimage,1);
cricket.target(2) = randi( size(arena,2)-2*size(cricket.orgimage,2)) + size(cricket.orgimage,2);
dtarget = cricket.target - cricket.position;
cricket.direction = cart2pol(dtarget(1),dtarget(2))/pi*180; % deg
cricket.image = 255-imrotate(cricket.orgimage,-cricket.direction,'crop');
end

function update_frame(~, ~)
global camera arena
camera = arena;
draw_cricket();
draw_mouse();
image(camera);
axis equal off xy;
disableDefaultInteractivity(gca);
drawnow
end

function draw_cricket()
global camera cricket frameperiod 

cricket.position = cricket.position + cricket.speed * frameperiod * [cos(cricket.direction * pi/180) sin(cricket.direction * pi/180)];

indx = round(cricket.position(1) - size(cricket.image,1)/2) + (1:size(cricket.image,1));
indy = round(cricket.position(2) - size(cricket.image,2)/2) + (1:size(cricket.image,2));
camera(indy,indx,:) = bitand(camera(indy,indx,:) , cricket.image(:,:,:));

if norm(cricket.target - cricket.position)<30
    set_cricket_target();
end

end

function draw_mouse()
global camera mouse frameperiod 

mouse.image = 255-imrotate(mouse.orgimage,270-mouse.direction,'crop');
mouse.speed = mouse.speed - frameperiod / 0.5 * mouse.speed;
newposition = mouse.position + mouse.speed * frameperiod * [cos(mouse.direction * pi/180) sin(mouse.direction * pi/180)];

indx = round(newposition(1) - size(mouse.image,1)/2) + (1:size(mouse.image,1));
indy = round(newposition(2) - size(mouse.image,2)/2) + (1:size(mouse.image,2));

try
    camera(indy,indx,:) = bitand(camera(indy,indx,:) , mouse.image(:,:,:));
    mouse.position = newposition;
catch 
    disp('close to side')
    mouse.speed = 0;
end

end
