function minilecture_debug
%minilecture_debug contains short lecture on debugging in matlab
% 2017, Alexander Heimel

% Matlab is an interpreter. It can directly execute your matlab code
% It is also easy to break into a function and halt it to examine the variables.
% You do this with by setting a breakpoint

dbstop 11 % set breakpoint at line 11

x = 2;

% once at the breakpoint, K>> to shows that you are interrupting something
% F10 takes a single step

dbstop 22

% F10 takes a single step jumping functions
x = factorial(x);

% F11 takes a step jumping into functions (Shift-F11 to escape)
x = factorial(x);

%dbcont continues execution (or to the next breakpoint)
% just like F5 or Run

dbclear all % clears all breakpoints 

dbstop 31
subminilecture(2131975);

% also useful is 

dbstop if error



% once we correct this, we can continue
% run the line below with F9

y = 1

% to quit debugger use
% dbquit

%% Sections you may run as a whole (Ctrl+Enter)
y = 1;
y = 3 * y;
y = factorial(y)

%% Until the next section
help dbstop

%% So where does debugging come from?
im = imread('Hopper_young.jpg');
h = figure('Name','Grace Hopper','NumberTitle','Off','Menu','None');
image(im);
axis image off
pause
close(h)

%% First computer bug
im = imread('moth.jpg');
h = figure('Name','First computer bug','NumberTitle','Off','Menu','None');
image(im);
axis image off
pause
close(h)

%% Useful things for debugging 

% Right-click on function
% Ctrl-D to open function in editor

help sin

%%

doc sin

%% lookfor looks for the topline in all functions, including yours

lookfor kruskal

%% 

% google is always your best friend

web 'www.google.nl/search?q=matlab+plot'

%% and if matlab did not have it, then somebody else usually already made it

web 'www.google.nl/search?q=matlab+plot+4d'

%% the web is full with Matlab tutorials and courses
% but if you want a quick fix of Matlab then check out
% Loren's Matlab blog

web 'http://blogs.mathworks.com/loren/'



function subminilecture(birthday)
disp(birthday);
dbstack
% shows where we are and who was calling





