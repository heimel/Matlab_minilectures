function excel_read_write_mac
%Written by Xing 09/06/15
%Open Excel, create a spreadsheet, write and save data.
%This example writes a mix of text and numeric data to the file sample_sheet.csv.
%Note that on a Mac, the function 'xlswrite' will not work, hence
%spreadsheet data is saved in the CSV format.
%Call dlmwrite, specifying the region 
%within the worksheet where you want to write the data. 

d={'Time', 'Temp'; 12 98; 13 99; 14 97};
% d = 
%     'Time'    'Temp'
%     [  12]    [  98]
%     [  13]    [  99]
%     [  14]    [  97]
d=[12 98; 13 99; 14 97];

%First input arg: excel file path. 
%Second: data to be written.
%Third: Name of sheet (if it does not currently exist, new sheet will be created)
%Fourth: Specify top-left cell in spreadsheet, to which data are written.
dlmwrite('/Users/Xing/Documents/NCL_work/GitHub/xing_PL_code/matlab_demos/sample_sheet.csv', d, 'roffset',4,'coffset',2);
