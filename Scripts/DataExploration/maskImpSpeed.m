%% Mask Impossible Speed
function [speedMatrixMasked] = maskImpSpeed(speedMatrix, impossibleValue, maskWith)
arguments
    speedMatrix;
    impossibleValue;
    maskWith (1,1) double = nan;
end
    idx = speedMatrix >= impossibleValue;
    speedMatrixMasked = speedMatrix;
    speedMatrixMasked(idx) = maskWith;
end