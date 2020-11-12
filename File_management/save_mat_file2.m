function save_mat_file2
%Written by Xing 9/6/15
%Example code for saving mat files

var1=[];
var2=[];
var3=[];

analysisType='spikeAct';
animal='jack';

overwriteMatFile=1;

analysisTimes=[0 500 1000 1500];
%3 analysis windows, from 0 to 500, 500 to 1000, and 1000 to 1500.

whichWindow=1;

%Set directory:
%rootFolder='C';
rootFolder='/Users/Xing/Documents/NCL_work/GitHub/xing_PL_code/matlab_demos';
subFolder=[num2str(analysisTimes(whichWindow)),'_',num2str(analysisTimes(whichWindow+1))];

folderPathName=fullfile(rootFolder,'matData',analysisType,animal,subFolder);%insert a '\'

%Check that dir exists, create it if not:
if ~exist(folderPathName,'dir')
    mkdir(folderPathName);
end

%Set file path:
saveMatText=[folderPathName,'/descriptiveMatFileName.mat'];

%Save file:
if ~exist(saveMatText,'file')||overwriteMatFile==1%check whether it already exists, or can be overwritten
    save(saveMatText,'var1','var2','var3')
end
