function [spatialHist, edges, edgesBin, activeArea] = spatialHistCalc(xy, numOfBinsHist, activeThresh)

%% Create empty variables
spatialHist = cell(size(xy));
edges = spatialHist;
edgesBin = spatialHist;
activeArea = spatialHist;

%% Calculate the sptial histogram of movements

for i = 1:size(xy,1)% for each movie file
    for day = 1:size(xy,2)
        
    colTemp = reshape(xy{i,day}(:, 1:2:end), [], 1);                                    % take the x values as matrix columns, and reshape into a vector
    rowTemp = reshape(xy{i,day}(:, 2:2:end), [], 1);                                    % take the y values as matrix rows, and reshape into a vector
    [spatialHist{i, day}, edges{i, day}(1, :), edges{i, day}(2, :)] = histcounts2(rowTemp, ...
        colTemp, [numOfBinsHist, numOfBinsHist]);                                   % make the histogram of the points - rows (y values) first for accurate image
    edgesBin{i, day} = [edges{i, day}(1,2)-edges{i, day}(1,1), edges{i, day}(2,2)-edges{i, day}(2,1)];
    activeArea{i, day} = spatialHist{i, day} > prctile(spatialHist{i, day}(:), activeThresh);      % calculate the active area as the lower percentile of activity in the arena
    
    clear xsTemp ysTemp spatialHistInd edgeSizeX edgeSizeY
    end

end
end