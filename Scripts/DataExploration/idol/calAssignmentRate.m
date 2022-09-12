function [assignmentRate] = calAssignmentRate(nans, lastframe, numOfFiles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
assignmentRate = cell(numOfFiles, 1);
for i = 1:numOfFiles
    assignmentRateRep = (lastframe - nans{i,1})./lastframe;
    assignmentRate{i,1} = assignmentRateRep(:,1:2:end);
end
end

