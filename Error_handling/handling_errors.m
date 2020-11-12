function handling_errors
%Catch and throw errors as they occur, and allow code to keep running,
%rather than getting stuck at the place where an error first occurred.

verbose=1;
sessionsList=1:10;%process data from ten sessions
data={1 2 [] 4 5 6 7 8 9 10}%missing data for the 3rd session 

errorMessages=[];%keep a list of any errors
for sessionCount=1:length(sessionsList)
    session = sessionsList(sessionCount);    
    if verbose
        fprintf('Processing session %d\n',session);%print session number to screen
    end
    
    try%try to process data for a given session
        processedData(sessionCount)=1/data{sessionCount};%process the data (insert your code here)
    catch ME%catch any errors
        if verbose
            fprintf('Error at session %d\n',session);%print session number to screen
        end        
        disp(ME);%print the error message to screen
        for i=1:length(ME.stack);
            errorMessages=[errorMessages;session {ME}];%append the error message to a list
        end
    end    
end
if ~isempty(errorMessages)
    for i=1:size(errorMessages,1)
        fprintf('\nError at session %d\n',errorMessages{i,1});%print problematic session number to screen
        errorMessages{i,2}.message%display error message
        errorMessages{i,2}.stack%print function and line number at which error occurred
    end
end