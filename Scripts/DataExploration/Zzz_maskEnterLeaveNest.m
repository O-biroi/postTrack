%% Mask speed matrix with NaN when ants are entering or leaving the nest
inNest = inNestWithNans{1,1};

%function [xyMasked] = maskEnterLeaveNest(xy, inNest)
    inNestRep = repelem(inNest,1, 2); % repeat column of inNest once to match the column number of xy
    inNestRepDiff = diff(inNestRep);
    
    %idx = find(inNestRep == 1);
    %xyMasked = xy;
    %xyMasked(idx) = nan;
%end