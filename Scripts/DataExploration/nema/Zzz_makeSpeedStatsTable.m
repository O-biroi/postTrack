function[speedStatsTable] = makeSpeedStatsTable(speedByContinuous, antOutput, numColonies, numSegments, numAnts, colonyID, antColour)
sz = numColonies*numSegments*numAnts;
vars = {'ColonyID','Colour','ContinuousSegment','MeanSpeed', 'AssignmentRate'};
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
speedStatsTable = join(outputSpeedTemp, antOutputHeader);

end
