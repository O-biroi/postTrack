%% Splits xy files (or inNest) files into segments to estimate temporal variation
% xy: xy files, cell array each row of the cell is one colony, only 1
% column. Within each cell is the merged xy axis.
% framesPerSegment: the number of frames one wants to have in each segments
% colPerAnt: bonus function, in case one wants to split other files with
% the same columns but each ant only occupies one column (e.g.
% inNestWithNans files)
function [xySplitted] = splitMergedXys(xy, framesPerSegment, colPerAnt)
arguments
    xy;
    framesPerSegment;
    colPerAnt (1,1) double = 2;
end

numFile = length(xy);
for i=1:numFile
    totalFramePerFile = size(xy{i,1},1);
    lastSegment = floor(totalFramePerFile./framesPerSegment);
    for j=1:lastSegment
        xySplitted{i,j}=xy{i,1}(1+(j-1)*framesPerSegment:j*framesPerSegment,:);
    end
end
end