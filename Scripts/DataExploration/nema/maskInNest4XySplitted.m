function [xyMasked] = maskInNest4XySplitted(xySplitted, inNestSplitted, colPerAnt, maskWith)
arguments    
    xySplitted;
    inNestSplitted;
    colPerAnt (1,1) double = 2;
    maskWith (1,1) double = nan;
end
numColonies  = size(xySplitted, 1);
numSegments  = size(xySplitted, 2);

for i = 1:numColonies
    for j = 1:numSegments
        xyMasked{i,j} = maskInNest(xySplitted{i,j}, inNestSplitted{i,j}, colPerAnt, maskWith);
    end
end

end
