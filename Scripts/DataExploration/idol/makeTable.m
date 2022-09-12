function [antTable] = makeTable(folderPath, numOfFiles, numOfAnts, antColours)

files=dir(fullfile(folderPath,'*.mat')); %find all the mat files

%% extract file information
for i = 1:numOfFiles
    names(i) = convertCharsToStrings(files(i,:).name);
    splitNames{i} = split(names(i),["_","."]);
    cameras(i) = splitNames{i}(2);
    colonyCam(i) = splitNames{i}(3);
    colony(i) = splitNames{i}(4);
end

%% initiate output table
sz = numOfFiles * numOfAnts;
vars = {'camera','colonyCam','colony'};
varTypes = {'string','string','string'};
antTable = table('Size',[sz,length(vars)], 'VariableTypes', varTypes, 'VariableNames', vars);

for i = 1:numOfFiles
    for j = 1:numOfAnts
    row = (i-1)*numOfFiles + j;
    antTable.camera(row) = cameras(i);
    antTable.colonyCam(row) = colonyCam(i);
    antTable.colony(row) = colony(i);
    antTable.antColour(row) = antColours(j);
    end
end
antTable.antID = strcat(antTable.camera, "_", antTable.colonyCam,"_", antTable.colony, "_", antTable.antColour);
end

