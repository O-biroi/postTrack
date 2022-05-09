function xy2 = cleanExtremeValues(xy, arenaSize)
    xy2 = [];
    for i = 1:size(xy, 1)
        %% Extract values
        xyTemp = xy(i, :);                                                  % get the date of the relevant colony
        xyTemp2 = cell2mat(xyTemp');                                        % extract the entire xy coordinates from the colony
        xTemp2 = xyTemp2(:, 1:2:end);
        yTemp2 = xyTemp2(:, 2:2:end);                                       % seperate x & y values
        newValuesX = checkCenter(xTemp2, arenaSize);                        % send to the other function
        newValuesY = checkCenter(yTemp2, arenaSize);

        %% Reconstruct values
        newValues = [newValuesX; newValuesY];                               % put x values above y values
        newValues = reshape(newValues, size(xyTemp2, 1), size(xyTemp2, 2)); % cut the matrix to xyTemp2 template
        newValues = reshape(newValues, size(xyTemp{1}, 1), ...
            size(xyTemp, 2), size(xyTemp{1}, 2));                           % cut the matrix to xyTemp{} dimension
        newValues = permute(newValues, [1, 3, 2]);                          % rearange the matrix to xyTemp{} template
        xy2Temp = squeeze(num2cell(newValues, [1, 2]))';                    % make matrix into cell array
        xy2 = cat(1, xy2, xy2Temp);                                         % store the data into new cell array
    end
end

function newValues = checkCenter(values, arenaSize)
    uniqueValues = unique(values(:));
    uniqueValues = uniqueValues(~isnan(uniqueValues));

    minValue = uniqueValues(1);
    maxValue = uniqueValues(end);
    
    if maxValue - minValue < arenaSize
        newValues = values;
        return
    end

    [histValues, histBins] = histcounts(uniqueValues, 20);
    currentValue = histBins(1);
    i = 0;
    
    while currentValue + arenaSize < maxValue || i == 20
        i = i + 1;
        window = histBins >= currentValue & histBins <= currentValue + arenaSize;
        numOfValues(i) = sum(histValues(window));
        currentValue = histBins(i + 1);
    end

    [~, maxNumOfValuesInd] = max(numOfValues);
    rightMinValue = histBins(maxNumOfValuesInd);
    values(values < rightMinValue | ...
        values > rightMinValue + arenaSize) = nan;
    newValues = values;
end



