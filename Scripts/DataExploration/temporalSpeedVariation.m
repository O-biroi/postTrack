%% Temporal variation of the behaviour
%% Settings
numFiles = 30;
framesPerContinuousSegment = 12000;
antColour = categorical(["BB","BG","BR","GG","GR","RB","RG","RR"]'); 
colonyID = outputFiltered.ColonyID;

%% Speed variation

% Merge xy2 files
xy2AllVideos = mergeSplittedXys(xy2, numFiles);
% Split xy2 files by continuous segments
% *ATTENTION*: only continuous segments of xy can be used for calculating
% speed
xy2ByContinuous = splitMergedXys(xy2AllVideos, framesPerContinuousSegment, 2);

% calculate speed matrices for all the cells in xy2ByContinuous
numColonies = size(xy2ByContinuous,1);
numSegments = width(xy2ByContinuous);
for i = 1:numColonies
    for j = 1:numSegments
        speedByContinuous{i,j} = calculateSpeed(xy2ByContinuous{i,j}, 8, 0.1, "mm/s");
    end
end

% calculate the mean speed for each ant in each 


%% Plotting

            