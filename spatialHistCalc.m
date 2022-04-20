function [spatialHist, edges2, edgesBin, activeArea2] = spatialHistCalc(xy, numOfBinsHist, activeThresh, arenaSize)

    %% Create empty variables
    spatialHist = cell(size(xy));
    edges2 = spatialHist;
    edgesBin = spatialHist;
    activeArea = spatialHist;
    edges = cell(size(xy,1));

    %% Calculate the sptial histogram of movements

    for i = 1:size(xy,1)% for each movie file
        [edges{i}, activeArea{i}] = arenaLimitsCalc(xy(i, :), arenaSize, numOfBinsHist, activeThresh);
        for day = 1:size(xy,2)
            [edges2{i, day}] = edges{i};
            colTemp = reshape(xy{i,day}(:, 1:2:end), [], 1);                                    % take the x values as matrix columns, and reshape into a vector
            rowTemp = reshape(xy{i,day}(:, 2:2:end), [], 1);                                    % take the y values as matrix rows, and reshape into a vector
            [spatialHist{i, day}] = histcounts2(rowTemp, colTemp, edges2{i, day}(1, :), edges2{i, day}(2, :));                                   % make the histogram of the points - rows (y values) first for accurate image
            edgesBin{i, day} = [edges2{i, day}(1,2)-edges2{i, day}(1,1), edges2{i, day}(2,2)-edges2{i, day}(2,1)];
%             activeArea{i, day} = spatialHist{i, day} > prctile(spatialHist{i, day}(:), activeThresh);      % calculate the active area as the lower percentile of activity in the arena
            activeArea2{i, day} = activeArea{i};
            clear xsTemp ysTemp spatialHistInd edgeSizeX edgeSizeY
        end


    end
end

function [edges, activeArea] = arenaLimitsCalc(xy, arenaSize, numOfBinsHist, activeThresh)
xyTemp = cell2mat(xy');
    xTemp = reshape(xyTemp(:,1:2:end), [], 1);
    yTemp = reshape(xyTemp(:,2:2:end), [], 1);
    maxX = max(xTemp);
    maxY = max(yTemp);
    minX = min(xTemp);
    minY = min(yTemp);

    countXMax = 0;
    for i = minX:0.0001:maxX - arenaSize
        countX = sum(xTemp > i & xTemp < i+arenaSize);
        if countXMax < countX
            countXMax = countX;
            arenaMinX = i;
        end
    end

    countYMax = 0;
    for i = minY:0.0001:maxY - arenaSize
        countY = sum(yTemp > i & yTemp < i+arenaSize);
        if countYMax < countY
            countYMax = countY;
            arenaMinY = i;
        end
    end
    if exist('arenaMinY')
        edges(1, :) = linspace(arenaMinY, arenaMinY + arenaSize, numOfBinsHist + 1);
    else
        edges(1, :) = linspace(minY, minY + arenaSize, numOfBinsHist + 1);
    end
    
    if exist('arenaMinX')
        edges(2, :) = linspace(arenaMinX, arenaMinX + arenaSize, numOfBinsHist + 1);
    else
        edges(2, :) = linspace(minX, minX + arenaSize, numOfBinsHist + 1);
    end
    totalHist = histcounts2(yTemp, xTemp, edges(1, :), edges(2, :));
    activeArea = totalHist > prctile(totalHist, activeThresh);      % calculate the active area as the lower percentile of activity in the arena
end
