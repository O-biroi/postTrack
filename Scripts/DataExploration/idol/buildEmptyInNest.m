function [inNest] = buildEmptyInNest(numOfFiles, numOfAnts, lastframe)
    inNest = cell(numOfFiles,1);
    inNest(:,:) = {zeros(lastframe, numOfAnts)};
end
