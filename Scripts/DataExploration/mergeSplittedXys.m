%% function mergeSplittedXys
% xy2: its filed either by interpolation (for less than 20 frames lost) or, 
% if in the nest, by the average location before and after got lost. 
% So, don't use this for velocity -  put nans where the ants are in nest, 
% and then use it for velocity.
% put NaNs in xy2 when the ants are in Nest
function [xyMerged] = mergeSplittedXys(xy, numFile)
mergeXy =cell2mat(xy');
for i=1:numFile
    xy2AllVideos{i,1} = mergeXy(:,1+(i-1)*16:i*16);
end
xyMerged = xy2AllVideos;
end