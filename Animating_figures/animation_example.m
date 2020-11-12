% ANIMATION_EXAMPLE
%
%   example of how to make an animation for Matlab course
%
% 2020, Alexander Heimel
clear all

max_t = 10; % s (seconds)
timestep = 0.03; % s 
max_steps = ceil(max_t / timestep);

current = rand(max_steps,1) - 0.5;
current = smooth( current, round(0.1/timestep));

potential = zeros(max_steps,1);
gamma = 0.1;
for i = 2:max_steps
    potential(i) = potential(i-1) + timestep * (current(i) - gamma * potential(i));
end

t = timestep * (0:max_steps-1);

vid = VideoWriter('animation_example.mp4');
vid.FrameRate = 1/timestep; % Hz
open(vid);
figure
hold on
xlabel('Time (s)');
ylabel('Potential (V)');
ylim([-0.3 0.3]);
for i = 1:max_steps
   h1 = plot( t(1:i),potential(1:i),'b'); 
   h2 = plot( t(i),potential(i),'or','MarkerFace',[1 0 0]);
   xlim( [t(i)-5 t(i)]);
   frame = getframe(gcf);
   writeVideo(vid,frame);
   delete(h1);
   delete(h2);
end
close(vid);
disp('Done creating animation');



