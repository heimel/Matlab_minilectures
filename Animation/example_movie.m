function example_movie
%EXAMPLE_MOVIE generates time plot and outputs movie
%
% 2019, Alexander Heimel

max_t = 4; % s

timestep = 0.01; % s
max_steps = max_t / timestep;

current = rand(max_steps,1)-0.5;

potential = zeros(max_steps,1);

for i = 1:(max_steps-1)
    potential(i+1) = potential(i) - timestep * potential(i) + timestep*current(i);
end
t = (0:(max_steps-1))*timestep;

vid = VideoWriter('example_movie.mp4');
vid.FrameRate = 1/timestep;
open(vid);

figure
for i=1:max_steps
    plot(t(1:i),potential(1:i))
    xlabel('Time (s)');
    ylabel('Potential (V)');
    xlim([ t(i)-3 t(i)]);
    ylim([-0.1 0.1]);
    frame = getframe(gcf);
    writeVideo(vid,frame);
end

close(vid);



