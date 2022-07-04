function[outputAntTable] = makeOutputAntTable(xySplitted, inNestSplitted, speedSplitted,numAnts, colonyID, antColour)

numColonies = size(xySplitted, 1);
numSegments = size(xySplitted, 2);
sz = numColonies*numSegments*numAnts;

vars = {'ColonyID','Colour','Day','AssignmentRate', 'MeanSpeed', 'MedianSpeed','InNestFrame', 'OutNestFrame', 'TotalFrame', 'OutNestRatio'};
varTypes = {'categorical','categorical','double','double', 'double', 'double','double', 'double', 'double', 'double'};

outputAntTable = table('Size',[sz,length(vars)], 'VariableTypes', varTypes, 'VariableNames', vars);

for i = 1:numColonies
    for j = 1:numSegments
        totalFrameXyPerAnt = size(xySplitted{i,j}, 1);
        for k = 1:numAnts
            numRow = (i-1)*numSegments*numAnts + (j-1)*numAnts +k;
            outputAntTable.ColonyID(numRow) = colonyID(i);
            outputAntTable.Colour(numRow) = antColour(k);
            outputAntTable.Day(numRow) = j;
            outputAntTable.AssignmentRate(numRow) = 1 - sum(isnan(xySplitted{i,j}(:,[k*2-1, k*2])),'all')/(totalFrameXyPerAnt*2);
            outputAntTable.MeanSpeed(numRow) = mean(speedSplitted{i, j}(:,k),"omitnan");
            outputAntTable.MedianSpeed(numRow) = median(speedSplitted{i, j}(:,k),"omitnan");
            outputAntTable.InNestFrame(numRow) = sum(inNestSplitted{i,j}(:,k),"omitnan");
            outputAntTable.TotalFrame(numRow) = (length(inNestSplitted{i,j}(:,k))-sum(sum(isnan(inNestSplitted{i,j}(:,k)))));
        end
    end
end

outputAntTable.OutNestFrame = outputAntTable.TotalFrame - outputAntTable.InNestFrame;
outputAntTable.OutNestRatio = outputAntTable.OutNestFrame ./ outputAntTable.TotalFrame;

end
