%% Temporal variation of the behaviour
%% Settings
numFiles = 30;
framesPerContinuousSegment = 12000;
framesPerDay = 144000;
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



%% In Nest variation
inNestWithNansByDay = splitMergedXys(inNestWithNans, framesPerDay, 1);

numColonies = length(colonyID);
numSegments = width(inNestWithNansByDay);
numAnts = length(antColour);

sz = numColonies*numSegments*numAnts;
vars = {'ColonyID','Colour','Day','InNestFrames','TotalFrames'};
varTypes = {'categorical','categorical','double','double','double'};

outputTemporal = table('Size',[sz,length(vars)], 'VariableTypes', varTypes, 'VariableNames', vars);

for i = 1:numColonies
    for j = 1:numSegments
        for k = 1:numAnts
            numRow = (i-1)*numSegments*numAnts + (j-1)*numAnts +k;
            outputTemporal.ColonyID(numRow) = colonyID(i);
            outputTemporal.Colour(numRow) = antColour(k);
            outputTemporal.Day(numRow) = j;
            outputTemporal.InNestFrames(numRow) = sum(inNestWithNansByDay{i, j}(:,k),"omitnan");
            outputTemporal.TotalFrames(numRow) = length(inNestWithNansByDay{i, j}(:,k)) - sum(isnan(inNestWithNansByDay{i, j}(:,k)));
        end
    end
end

antOutputHeader = antOutput(:,["ColonyID","Treatment","Colour","InfectionLoad","InfectionStatus"]);
outTemporalFull = join(outputTemporal, antOutputHeader);
outTemporalFull.AssignmentRate = outTemporalFull.TotalFrames/framesPerDay;
outTemporalFull.OutNestFrames = outTemporalFull.TotalFrames -  outTemporalFull.InNestFrames;
outTemporalFull.OutNestRatio =outTemporalFull.OutNestFrames./outTemporalFull.TotalFrames;

writetable(outTemporalFull, "outTemporalFull.csv")
%% Plotting

            