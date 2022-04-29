%% Mask xy matrix with NaN when ants are in nest
function [xyMasked] = maskInNest(xy, inNest)
    inNestRep = repelem(inNest,1, 2);
    idx = find(inNestRep == 1);
    xyMasked = xy;
    xyMasked(idx) = nan;
end