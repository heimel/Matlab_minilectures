%COURSE_PROGRAM reads program from excel and shows in table
%
% 2019, Alexander Heimel

[num,txt] = xlsread('Matlab ONWAR Course Program 2019.xlsx');

figure
h = uitable('Data',txt,'Units','Normalized','Position',[0 0 1 1]);
h.ColumnWidth = {100,300,100};
h.RowName = [];
