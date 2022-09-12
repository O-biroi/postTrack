function [nans] = countNans(xy, numOfFiles)
nans = cell(numOfFiles,1);
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
for i =  1:numOfFiles
    nans{i,1} = sum(isnan(xy{i,1}),1);
end

