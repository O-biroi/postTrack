%% Mask matrices with NaN when ants are in nest
function [outputMasked] = maskInNest(inputToMask, inNest, colPerAnt, maskWith)
arguments
    inputToMask;
    inNest;
    colPerAnt (1,1) double = 2;
    maskWith (1,1) double = nan;
end

if colPerAnt == 2 % e.g. for xy matrices
    inNestRep = repelem(inNest,1, 2); % repeat column of inNest once to match the column number of xy
    idx = inNestRep == 1; % logical returns index with fast speed
    outputMasked = inputToMask;
    outputMasked(idx) = maskWith;

elseif colPerAnt == 1 % e.g. for speed matrices
    idx = inNest == 1;
    outputMasked = inputToMask;
    outputMasked(idx) = maskWith; 
end

end