%% Temporal variation of the Speed

%% Settings
numFiles = 30;
framesPerContinuousSegment = 12000;
antColour = categorical(["BB","BG","BR","GG","GR","RB","RG","RR"]'); 
colonyID = outputFiltered.ColonyID;

%% Data Preparation
% Merge and resplit xy2 files
xy2AllVideos = mergeSplittedXys(xy2, numFiles);
xy2ByContinuous = splitMergedXys(xy2AllVideos, framesPerContinuousSegment, 2);
% resplit inNestWithNans
inNestWithNansByContinuous = splitMergedXys(inNestWithNans, framesPerContinuousSegment, 1);

% Prepare arguments for the following functions
numColonies = size(xy2ByContinuous,1);
numSegments = size(xy2ByContinuous,2);
numAnts = length(antColour);
secondEachFrame = 0.1;
unit = "mm/s";

%% Out Nest Speed variation 
% Mask ants when in Nest
xy2ByContinuousOutNest = cell(numColonies, numSegments);

for i = 1:numColonies
    for j = 1:numSegments
        xy2ByContinuousOutNest{i,j} = maskInNest(xy2ByContinuous{i,j}, inNestWithNansByContinuous{i,j}, 2, nan);
    end
end

% Split xy2 files by continuous segments
% *ATTENTION*: only continuous segments of xy can be used for calculating speed
speedByContinuousOutNest = calculateSpeed4XySplitted(xy2ByContinuousOutNest, numColonies, numSegments, numAnts, secondEachFrame, unit);
speedTableOutNest = makeSpeedStatsTable(speedByContinuousOutNest, antOutput, numColonies, numSegments, numAnts, colonyID, antColour);
% writetable(outputSpeedTempFull, "outNestSpeedTemporalFull.csv")

%% Total Speed variation
% When ant in nest, put the speed into zero (this is to remove jumping
% when ants join and leave the nest)
speedByContinuousTotal = cell(numColonies, numSegments);
inNestWithNansByContinuousShift = circshift(inNestWithNansByContinuous, -1, 1); % shift the rows so it matches with speed matrix

for i = 1:numColonies
    for j = 1:numSegments
        speedByContinuousTotal{i,j} = maskInNest(speedByContinuousOutNest{i,j}, inNestWithNansByContinuousShift{i,j}(1:end-1,:), 1, 0);
    end
end
speedTableTotal = makeSpeedStatsTable(speedByContinuousTotal, antOutput, numColonies, numSegments, numAnts, colonyID, antColour);

