%% Temporal variation of outNestRatio
%% Settings
numFiles = 30;
framesPerDay = 144000;
antColour = categorical(["BB","BG","BR","GG","GR","RB","RG","RR"]'); 
colonyID = outputFiltered.ColonyID;

%% Out Nest variation
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