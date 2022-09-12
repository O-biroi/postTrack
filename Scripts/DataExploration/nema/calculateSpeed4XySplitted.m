% calculate speed matrices for all the cells in xy2ByContinuous
function [speedByContinuous] = calculateSpeed4XySplitted(xySplitted, numAnts, secondEachFrame, unit)

numColonies = size(xySplitted, 1);
numSegments = size(xySplitted, 2);

for i = 1:numColonies
    for j = 1:numSegments
        speedByContinuous{i,j} = calculateSpeed(xySplitted{i,j}, numAnts, secondEachFrame, unit);
    end
end

end
