%% Temporal variation of the behaviour
%% Settings
numFiles = 30;
framesPerContinuousSegment = 12000;
antColour = categorical(["BB","BG","BR","GG","GR","RB","RG","RR"]'); 
colonyID = outputFiltered.ColonyID;

%% Speed variation
numColonies = size(xy2ByContinuous,1);
numSegments = width(speedByContinuous);
numAnts = length(antColour);

% Merge xy2 files
xy2AllVideos = mergeSplittedXys(xy2, numFiles);
% Split xy2 files by continuous segments
% *ATTENTION*: only continuous segments of xy can be used for calculating
% speed
xy2ByContinuous = splitMergedXys(xy2AllVideos, framesPerContinuousSegment, 2);

% calculate speed matrices for all the cells in xy2ByContinuous
for i = 1:numColonies
    for j = 1:numSegments
        speedByContinuous{i,j} = calculateSpeed(xy2ByContinuous{i,j}, numAnts, 0.1, "mm/s");
    end
end

% calculate the mean speed for each ant in each 
sz = numColonies*numSegments*numAnts;
vars = {'ColonyID','Colour','ContinuousSegment','MeanSpeed', 'AsssignmentRate'};
varTypes = {'categorical','categorical','double','double', 'double'};

outputSpeedTemp = table('Size',[sz,length(vars)], 'VariableTypes', varTypes, 'VariableNames', vars);

for i = 1:numColonies
    for j = 1:numSegments
        totalFrame = size(speedByContinuous{i,j},1);
        for k = 1:numAnts
            numRow = (i-1)*numSegments*numAnts + (j-1)*numAnts +k;
            outputSpeedTemp.ColonyID(numRow) = colonyID(i);
            outputSpeedTemp.Colour(numRow) = antColour(k);
            outputSpeedTemp.ContinuousSegment(numRow) = j;
            outputSpeedTemp.MeanSpeed(numRow) = mean(speedByContinuous{i, j}(:,k),"omitnan");
            outputSpeedTemp.AssignmentRate(numRow) = 1- sum(sum(isnan(speedByContinuous{i, j}(:,k))))/totalFrame;
        end
    end
end

antOutputHeader = antOutput(:,["ColonyID","Treatment","Colour","InfectionLoad","InfectionStatus"]);
outputSpeedTempFull = join(outputSpeedTemp, antOutputHeader);
%outputSpeedTempFull.AssignmentRate = outputSpeedTempFull.TotalFrames/framesPerDay;

writetable(outputSpeedTempFull, "outputSpeedTemporalFull.csv")

%% Plotting

            