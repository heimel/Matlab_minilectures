% MOVIE_EXAMPLE
%
%   example of how to make a movie for Matlab course
%
% 2020, Alexander Heimel


max_t = 10; % s (seconds)
timestep = 0.01; % s 
max_steps = max_t / timestep;

current = rand(max_steps,1) - 0.5;
current = smooth( current, round(0.1/timestep));

potential = zeros(max_steps,1);

gamma = 0.1;
for i = 2:max_steps
    potential(i) = potential(i-1) + timestep * (current(i) - gamma * potential(i));
end

t = timestep * (0:max_steps-1);

vid = VideoWriter('coolmovie.mp4');
vid.FrameRate = 1/timestep;
open(vid);
figure

for i = 1:max_steps
   plot( t(1:i),potential(1:i),'b') 
   hold on
   plot( t(i),potential(i),'or');
   hold off
   xlabel('Time (s)');
   ylabel('Potential (V)');
   ylim([-0.2 0.2]);
   xlim( [t(i)-5 t(i)]);
   frame = getframe(gcf);
   writeVideo(vid,frame);
end
close(vid);




