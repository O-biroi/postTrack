function [SpeedSplittedMasked] = maskImpSpeed4SpeedSplitted(SpeedSplitted, impossibleValue, maskWith)
arguments    
    SpeedSplitted;
    impossibleValue;
    maskWith (1,1) double = nan;
end
numColonies  = size(SpeedSplitted, 1);
numSegments  = size(SpeedSplitted, 2);

for i = 1:numColonies
    for j = 1:numSegments
        SpeedSplittedMasked{i,j} = maskImpSpeed(SpeedSplitted{i,j}, impossibleValue, maskWith);
    end
end

end