% calculate speed matrices for all the cells in xy2ByContinuous
function [speedByContinuous] = calculateSpeed4XySplitted(xySplitted, numColonies, numSegments, numAnts, secondEachFrame, unit)


for i = 1:numColonies
    for j = 1:numSegments
        speedByContinuous{i,j} = calculateSpeed(xySplitted{i,j}, numAnts, secondEachFrame, unit);
    end
end

end
