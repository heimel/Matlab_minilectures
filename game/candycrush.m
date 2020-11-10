function candycrush
%CANDYCRUSH implementation of the eponymous game
%
% 2019, Alexander Heimel

n_x = 6;
n_y = 8;
n_c = 5;

arena = zeros(n_y,n_x);

h = figure('Name','Candycrush','NumberTitle','off');

show_arena(h,arena,n_c);
score = 0;
changed = true;
while changed
    getcoordinates;
    [arena,changed_gravity] = apply_gravity(arena);
    [arena,changed_fill] = fill_top(arena,n_c);
    [arena,changed_remove,score_increase] = remove_triplets(arena);
    score = score + score_increase;
    changed = changed_gravity | changed_fill | changed_remove;
    show_arena(h,arena,n_c);
    if changed
        pause(0.1);
    else
        
        while ~changed
            [xs(1),ys(1)] = getcoordinates;
            [xs(2),ys(2)] = getcoordinates;
            
            if diff(xs)^2 + diff(ys)^2 == 1
                arena = try_swap(arena,xs,ys);
                show_arena(h,arena,n_c);
                pause(0.1);
                [~,changed] = remove_triplets(arena);
                if ~changed
                    arena = try_swap(arena,xs,ys); % swap back
                end
                show_arena(h,arena,n_c);
            end
        end
    end
end

function [x,y] = getcoordinates
persistent prev_curpoint

if isempty(prev_curpoint) || nargout == 0
    prev_curpoint = get(gca,'CurrentPoint');
    return
end

curpoint = get(gca,'CurrentPoint');
while all(curpoint==prev_curpoint)
    curpoint = get(gca,'CurrentPoint');
    pause(0.001);
end
prev_curpoint = curpoint;
x = ceil(curpoint(1,1)/39);
y = ceil(curpoint(1,2)/39);


function arena = try_swap(arena,xs,ys);
temp = arena(ys(1),xs(1));
arena(ys(1),xs(1)) = arena(ys(2),xs(2));
arena(ys(2),xs(2)) = temp;

function [arena,changed,score] = remove_triplets(arena)
changed = false;
score = 0;
new_arena = arena;
% remove horizontal triples
for y=1:size(arena,1)
    for x=1:size(arena,2)-2
        if arena(y,x)==arena(y,x+1) && arena(y,x)==arena(y,x+2)
            new_arena(y,x+[0 1 2]) = 0;
            changed = true;
            score = score + 1;
        end
    end
end
% remove vertical triplets
for x=1:size(arena,2)
    for y=1:size(arena,1)-2
        if arena(y,x)==arena(y+1,x) && arena(y+2,x)==arena(y,x)
            new_arena(y+[0 1 2],x) = 0;
            changed = true;
            score = score + 1;
        end
    end
end

arena = new_arena;

function [arena,changed] = fill_top(arena,n_c)
changed = false;
for x=1:size(arena,2)
    if arena(end,x)==0
        arena(end,x) = randi(n_c);
        changed = true;
    end
end

function [arena,changed] = apply_gravity(arena)
changed = false;
for y=1:size(arena,1)-1
    for x=1:size(arena,2)
        if arena(y,x)==0
            arena(y,x) = arena(y+1,x);
            arena(y+1,x) = 0;
            changed = true;
        end
    end
end


function show_arena(h,arena,n_c)
persistent candy s

if isempty(candy)
    s = 39;
    im = imread('candy-crush-saga.jpg');
    x = 4;
    y = 0;
    candy{1}=im(y+(1:s),x+(1:s),:);
    candy{2}=im(y+(1:s),x+s+(1:s),:);
    candy{3}=im(y+(1:s),x+3*s+(1:s),:);
    candy{4}=im(y+s+(1:s),x+3*s+(1:s),:);
    candy{5}=im(y+2*s+(1:s),x+s+(1:s),:);
    
%     figure
%     for i=1:5
%         subplot(1,5,i)
%         image(candy{i});
%         axis image 
%     end
end

im = zeros([size(arena)*s 3],'uint8');
for y = 1:size(arena,1)
    for x = 1:size(arena,2)
        if arena(y,x)~=0
            im((1+(y-1)*s):(y*s),(1+(x-1)*s):(x*s),:) = candy{arena(y,x)};
        end
    end
end

image(im);
% colmap = [0.7 0.7 0.7;hsv(n_c)];
% image('CData',uint8(arena));
% colormap(colmap);
% set(gca,'clim',[0 n_c+1])
axis square off
set(gca,'ydir','normal');
