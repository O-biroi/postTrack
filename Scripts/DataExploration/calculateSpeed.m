%% Calculate Speed Matrices with XY Matrices
% by default the unit for the speed is "m/s"
function [speedMatrix] = calculateSpeed(xyMatrix, numAnts,secondEachFrame, unit)
arguments
    xyMatrix double;
    numAnts (1,1) double;
    secondEachFrame (1,1) double;
    unit (1,1) string = "m/s";
end
for i = 1:numAnts
    % calculate Pythagoras distance of each step of frames and then
    % divide distance by the second between each frame 
    diffMatrix = diff(xyMatrix);
    speedMatrix(:,i) = (sqrt((diffMatrix(:,2*i-1)).^2 + (diffMatrix(:,2*i)).^2))/secondEachFrame;
end
if unit == "mm/s"
    speedMatrix = 1000*speedMatrix;
else if unit == "cm/s"
    speedMatrix = 100*speedMatrix;
end
end