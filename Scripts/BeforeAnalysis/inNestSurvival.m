% run it section by section
clear;
%% read parameters
parameters.rootPath ='/Volumes/Zim_Private/idol/';
parameters.antColour = ["BG","BO","GB","GP","OB","OG","OP","PB","PG","PO"];
files=dir(fullfile(strcat(parameters.rootPath, '/all/inNest'), '*.mat')); %find all the mat files
parameters.numCam = size(files,1);
parameters.numOfAnts = 10;
parameters.totalAnts = 80;

%% store camera information
for i = 1:parameters.numCam
    names{i} = files(i,:).name;
    splitNames{i} = split(string(names{i}),["_","."]);
    cameras{i} = splitNames{i}(2);
end
%% initiate output table
sz = parameters.totalAnts;
vars = {'camera','colonyCam','colour','assignmentRate','inNestFrames', 'outNestFrames', 'totalFrames', 'outNestRatio'};
varTypes = {'categorical','categorical','categorical','double','double', 'double', 'double','double'};
outputAntTable = table('Size',[sz,length(vars)], 'VariableTypes', varTypes, 'VariableNames', vars);

%% calculate and assign metrics in output table
for i = 1:parameters.numCam
    inNest = load(fullfile(files(i,:).folder,files(i,:).name)).inNest;
    frames = size(inNest, 1);
    numColony = size(inNest,2)/parameters.numOfAnts;
    nanNum = sum(isnan(inNest));
    totalFrames = frames - nanNum;
    assignmentRate =  totalFrames ./ frames;
    sumInNest = nansum(inNest);
    sumOutNest = totalFrames - sumInNest;
    outNestRatio = sumOutNest ./ totalFrames ;
    for j = 1:numColony
        for k = 1:parameters.numOfAnts
            numRow = (i-1)*numColony*parameters.numOfAnts + (j-1)*parameters.numOfAnts +k;
            outputAntTable.camera(numRow) = cameras{i};
            outputAntTable.colonyCam(numRow) = categorical(j);
            outputAntTable.colour(numRow) = categorical(parameters.antColour(k));
            outputAntTable.assignmentRate(numRow) = assignmentRate((j-1)*parameters.numOfAnts +k);
            outputAntTable.inNestFrames(numRow) = sumInNest((j-1)*parameters.numOfAnts +k);
            outputAntTable.outNestFrames(numRow) = sumOutNest((j-1)*parameters.numOfAnts +k);
            outputAntTable.totalFrames(numRow) = totalFrames((j-1)*parameters.numOfAnts +k);
            outputAntTable.outNestRatio(numRow) = outNestRatio((j-1)*parameters.numOfAnts +k);
        end
    end
end
%% save as .csv file
[filename, pathname] = uiputfile('*.csv');
writetable(outputAntTable, [pathname,filename]);