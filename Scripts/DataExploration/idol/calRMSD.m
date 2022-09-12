function [rmsd] = callRMSD(xy, nans, lastframe, numOfFiles, numOfAnts)
% function that calculates the rmsd from the merged experiment xy cell 
% variable

% initiation
center = cell(numOfFiles, 1);
rmsd = cell(numOfFiles, 1);
realFrameNum = cell(numOfFiles, 1);
sumDeviation = cell(numOfFiles, 1);
realFrameNumPerAnt = cell(numOfFiles, 1);
sumSquaredDeviation = cell(numOfFiles, 1);

for i =  1:numOfFiles
    center{i,1} = nanmean(xy{i,1}); % calculate mean xy position for each colony
    realFrameNum{i,1}  = lastframe - nans{i,1}; % calculate the number of frames without nans for each colony
    sumSquaredDeviation{i,1} = nansum((xy{i,1} - center{i,1}).^2,1); % calculate the sum squared deviation for each colony
    for j = 1:numOfAnts % column numbers halved from here (metrics are calucalted for x and y together)
    sumDeviation{i,1}(1,j) = (sumSquaredDeviation{i,1}(1,j*2-1) + sumSquaredDeviation{i,1}(1,j*2)); % sum the deviation of x and y
    realFrameNumPerAnt{i,1}(1,j) = realFrameNum{i,1}(1,j*2-1); % only take one real frame number for each ant
    end
    rmsd{i,1}= sqrt(sumDeviation{i,1}./realFrameNumPerAnt{i,1}); % calculate rmsd
end