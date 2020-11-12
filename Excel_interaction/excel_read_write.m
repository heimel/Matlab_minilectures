function excel_read_write
%Written by Xing 29/05/14
%Open Excel, create a spreadsheet, write and save data.
%This example writes a mix of text and numeric data to the file climate.xls. 
%Call xlswrite, specifying a worksheet labeled Temperatures, and the region 
%within the worksheet where you want to write the data. 
%xlswrite writes the 4-by-2 matrix d to the rectangular region that starts 
%at cell E1 in its upper-left corner.

d={'Time', 'Temp'; 12 98; 13 99; 14 97};
% d = 
%     'Time'    'Temp'
%     [  12]    [  98]
%     [  13]    [  99]
%     [  14]    [  97]

%First input arg: excel file path. 
%Second: data to be written.
%Third: Name of sheet (if it does not currently exist, new sheet will be created)
%Fourth: Specify top-left cell in spreadsheet, to which data are written.
xlswrite('H:\GitHub\xing_PL_code\matlab_demos\sample_sheet.xlsx', d, 'Temperatures', 'E3');

%Retrieve info about a spreadsheet:
[type, sheets] = xlsfinfo('H:\GitHub\xing_PL_code\matlab_demos\sample_sheet.xlsx')

%Read data from a spreadsheet:
ndata = xlsread('H:\GitHub\xing_PL_code\matlab_demos\sample_sheet.xlsx', 'Temperatures')

%Read separate variables for numbers, text, etc:
[num,txt,raw] = xlsread('H:\GitHub\xing_PL_code\matlab_demos\sample_sheet.xlsx', 'Temperatures')%additionally returns the text fields in cell array txt, and the unprocessed data (numbers and text) in cell array raw using any of the input arguments in the previous syntaxes. If xlRange is specified, leading blank rows and columns in the worksheet that precede rows and columns with data are returned in raw. 