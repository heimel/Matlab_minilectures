function parfor_sample_code
%Written by Xing 11/07/14

%Examples of how to use parfor loops, how to split the data processing into
%distinct stages.
%Open workers using this command:
matlabpool open

%20 files of raw data to be processed per day.
%Total of 10 days.
files=1:20;
days=1:10;

%Scenario 1: data files can be processed completely independently of each
%other.
totalFiles=length(files)*length(days)

parfor processNumber=1:totalFiles
    %process the data here:
    dayNumber=floor(processNumber/20)+1;
    fileNumber=mod(processNumber,20)+1;
    sprintf('process number %s, file #%s, day %s',num2str(processNumber),num2str(fileNumber),num2str(dayNumber))
end


%Scenario 2: data files can be processed semi-independently of each
%other- possible to process several file 'numbers' at a time, e.g. file 1
%from day 1 and file 2 from day 1, but NOT several days simultaneously for
%a given file number, e.g. file 1 from day 1 and file 1 from day 2.
totalRuns=length(files)

parfor fileNumber=1:totalRuns
    %process the data here, in an orderly sequence from day 1 to day 10:
    for dayCounter=1:length(days)
        sprintf('file #%s, day %s',num2str(fileNumber),num2str(dayCounter))
    end
end

%slow down the processing, so that you can see the order- file numbers may
%be processed out of sequence, but for a given file number, days will
%always be processed in sequence:
parfor fileNumber=1:totalRuns
    %process the data here, in an orderly sequence from day 1 to day 10:
    for dayCounter=1:length(days)
        sprintf('file #%s, day %s',num2str(fileNumber),num2str(dayCounter))
        pause(1)
    end
end
