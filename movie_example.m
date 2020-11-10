%MOVIE_EXAMPLE
%
% 2019, Alexander Heimel

max_t = 10;
timestep = 0.1;
max_steps = max_t / timestep;

current = (rand(max_steps,1)-0.5);
current = smooth(current,round(0.1/timestep));


gamma = 0.1;

potential = zeros(1,max_steps);
for i  = 2:max_steps
   potential(i) = potential(i-1) + timestep * ( current(i) - gamma*potential(i-1) ); 
end
t = timestep * (0:max_steps-1);

vid = VideoWriter('plotje.mp4');
vid.FrameRate = 1/timestep;
open(vid);
figure;
for i = 1:max_steps
    plot(t(1:i),potential(1:i));
    hold on
    plot(t(i),potential(i),'or','markerfacecolor',[1 0 0]);
    xlim([t(i)-5 t(i)]);
    ylim([-1 1]);
    hold off
    box off
    xlabel('Time (s)');
    ylabel('Potential (V)');
    frame = getframe(gcf);
    writeVideo(vid,frame);    
end
close(vid);
