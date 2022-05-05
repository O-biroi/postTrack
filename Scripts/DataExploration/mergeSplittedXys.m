%% function mergeSplittedXys
% xy2: its filed either by interpolation (for less than 20 frames lost) or, 
% if in the nest, by the average location before and after got lost. 
% So, don't use this for velocity -  put nans where the ants are in nest, 
% and then use it for velocity.
% put NaNs in xy2 when the ants are in Nest
function [xyMerged] = mergeSplittedXys(xy, numAnts, colPerAnt)
arguments
    xy;
    numAnts;
    colPerAnt (1,1) double = 2;
end
    
numFile = size(xy, 1);
mergeXy =cell2mat(xy');
for i=1:numFile
    if colPerAnt == 2
    xy2AllVideos{i,1} = mergeXy(:,1+(i-1)*2*numAnts:i*2*numAnts);
    elseif colPerAnt == 1
    xy2AllVideos{i,1} = mergeXy(:,1+(i-1)*numAnts:i*numAnts);   
end
xyMerged = xy2AllVideos;
end