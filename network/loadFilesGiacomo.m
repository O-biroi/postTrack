function [xy, inNest, numOfFiles] = loadFilesGiacomo(framesToDivide, numOfDivs, folderPath)

    % framesToDivide = 6000;
    % numOfDivs = 1;
    % folderPath = '/Users/daniel/Desktop/nosync.nosync/Nest_Interpolation/y';

    files = dir(fullfile(folderPath,'*.mat'));                             % find all mat files in the folder
    for i = 1:length(files)
        varNames = {'ant_xy', 'ant_nest'};                                 % load the variables parameters
        load(fullfile(files(i).folder, files(i).name), varNames{:});        
        for in = 1:numOfDivs                                               % divide the variables into parts
            xy{i, in} = ant_xy((in-1)*framesToDivide+1:in*framesToDivide, :);
            inNest{i, in} = ant_nest((in-1)*framesToDivide+1:in*framesToDivide, :);
        end
    end
    numOfFiles = i;
end
