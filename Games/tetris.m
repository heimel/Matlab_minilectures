function tetris
%TETRIS game
%
% 2019, Alexander Heimel

global key

width = 15;
height = 23;
key = '';

arena = zeros(height,width,'uint8');
arena(end-2:end,:) = 1; % bottom wall
arena(:,1:3) = 1; % left wall
arena(:,end-2:end) = 1; % right wall

block = zeros(5,4,4,'uint8');
block(1,:,:) = 2*[ 0 0 0 0 ; ...
                 0 0 0 0 ; ...
                 1 1 1 1 ; ...
                 0 0 0 0 ];
block(2,:,:) = 3* [ 0 0 0 0; ...
                     1 0 0 0; ...
                     1 1 1 0; ...
                     0 0 0 0 ];
block(3,:,:) = 4*[ 0 0 0 0; ...
                     0 0 0 1; ...
                     0 1 1 1; ...
                     0 0 0 0 ];
block(4,:,:) = 5* [ 0 0 0 0; ...
                     0 1 1 0; ...
                     0 1 1 0; ...
                     0 0 0 0 ];
block(5,:,:) = 6*[ 0 0 0 0; ...
                     0 1 1 1; ...
                     0 0 1 0; ...
                     0 0 0 0 ];

figure('Name','Tetris','NumberTitle','off');
set(gcf,'KeyPressFcn',@keypressed);

[r,c,current_block] = get_new_block( block );
arena = place_block(arena,r,c,current_block);



framerate = 4; %fps
frameinterval = 1/framerate;

score = 0;
dead = false;
while ~dead
    time = now;
    switch key
        case 'leftarrow'
            if can_move(arena,r,c,r,c-1,current_block)
                arena = remove_block(arena,r,c,current_block);
                c = c - 1;
                arena = place_block(arena,r,c,current_block);
            end
        case 'rightarrow'
            if can_move(arena,r,c,r,c+1,current_block)
                arena = remove_block(arena,r,c,current_block);
                c = c + 1;
                arena = place_block(arena,r,c,current_block);
            end
        case {'downarrow' ,'space' }
            frameinterval = 0.01;
        case 'uparrow' 
            ncurrent_block = rotate_block(squeeze(current_block));
            if can_move(arena,r,c,r,c,current_block,ncurrent_block)
                arena = remove_block(arena,r,c,current_block);
                current_block = ncurrent_block;
                arena = place_block(arena,r,c,current_block);
            end
    end
    key = '';
    if can_move(arena,r,c,r+1,c,current_block)
        arena = remove_block(arena,r,c,current_block);
        r = r + 1;
        arena = place_block(arena,r,c,current_block);
    elseif r==1 % top row 
        dead = true;
        break
    else
        frameinterval = 1/framerate;
        [arena,score] = remove_complete_rows(arena,score);
        [r,c,current_block] = get_new_block( block );
        arena = place_block(arena,r,c,current_block);
    end        
    show_arena(arena)
    waittime = (frameinterval - (now-time));
    pause(max(0,waittime));    
end
disp('YOU DIED');       
disp(['Your score was ' num2str(score)]);

function nblock = rotate_block(block)
nblock = rot90(block);

function [arena,score] = remove_complete_rows(arena,score)
for i=(size(arena,1)-3):-1:1
    if all(arena(i,:)>0)
        arena(2:i,4:end-3) = arena(1:i-1,4:end-3);
        arena(1,4:end-3)= 0;
    end
    score = score + 1;
end
    
function  ret = can_move(arena,r,c,nr,nc,current_block,ncurrent_block)
if nargin<7 || isempty(ncurrent_block)
    ncurrent_block = current_block;
end
arena  = remove_block(arena,r,c,current_block);
ret = ~any( any( logical(arena(nr:nr+3,nc:nc+3)) & logical(squeeze(ncurrent_block)) ));

function arena = place_block(arena,r,c,current_block)
arena(r:r+3,c:c+3) = arena(r:r+3,c:c+3) + squeeze(current_block);

function arena  = remove_block(arena,r,c,current_block)
arena(r:r+3,c:c+3) = arena(r:r+3,c:c+3) - squeeze(current_block);

function show_arena(arena)
image(10*arena(1:end-2,3:end-2));
%imshow(arena(1:end-2,3:end-2),colormap('prism'));
%colormap prism
set(gca, 'xlimmode','manual',...
           'ylimmode','manual',...
           'zlimmode','manual',...
           'climmode','manual',...
           'alimmode','manual');

function [r,c,current_block] = get_new_block( block )
c = 7;
r = 1;
current_block = block(randi(size(block,1)),:,:);

function keypressed(src,event)
global key
key = event.Key;

