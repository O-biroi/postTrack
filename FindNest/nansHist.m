function [sumHistPosNans, beginNansInd, endNansInd] = nansHist(xy, activeArea, edges, numOfAnts)
% dbstop if error
for i = 1:size(xy,1)        %loop all colonies
    for day = 1:sum((~cellfun(@isempty,xy(i,:))))

    %% Calculate the durations & positions of the unrecognized sequences
    % Find unrecognized frames
    nans = isnan(xy{i,day});
    diffNans = diff(nans);
    counter{i,day} = cell(1, size(xy{i,day}, 2) / 2);
    posBeginNanSum{i,day} = [];
    
    for in = 1:numOfAnts%size(xy{i,day}, 2) / 2  %loop all individuals
        
        xyTemp = [xy{i,day}(:, in * 2 - 1), xy{i,day}(:, in * 2)];
        counterTemp1 = [];
        counterTemp2 = [];
        flag = [];
        
        if all(isnan(xyTemp)) %GA ignore individuals with all missing data
            histPosNans{i,day}(in, :, :)=zeros(length(edges{i,day}(1, :)) - 1, length(edges{i,day}(2, :)) - 1);
            continue
        end
        
        beginNans = [diffNans(:, in * 2) == 1; 0];
        endNans = [0; diffNans(:, in * 2) == -1];
        beginNansInd{i,day, in} = find(beginNans);
        if isempty(beginNansInd{i, day, in})
            histPosNans{i,day}(in, :, :)=zeros(length(edges{i,day}(1, :)) - 1, length(edges{i,day}(2, :)) - 1);
            continue
        end
        endNansInd{i,day, in} = find(endNans);
        if isempty(endNansInd{i, day, in})
            histPosNans{i,day}(in, :, :)=zeros(length(edges{i,day}(1, :)) - 1, length(edges{i,day}(2, :)) - 1);
                continue
        end
        
        if beginNansInd{i,day, in}(1) >= endNansInd{i,day, in}(1)
            endNans(endNansInd{i,day, in}(1)) = 0;
            endNansInd{i,day, in}(1) = [];
        end
        if isempty(endNansInd{i, day, in})
            histPosNans{i,day}(in, :, :)=zeros(length(edges{i,day}(1, :)) - 1, length(edges{i,day}(2, :)) - 1);
                continue
        end
        if endNansInd{i,day, in}(end) <= beginNansInd{i,day, in}(end)
            beginNans(beginNansInd{i,day, in}(end)) = 0;
            beginNansInd{i,day, in}(end) = [];
        end
      
        posBeginNan = [xy{i,day}(logical(beginNans), in*2-1), xy{i,day}(logical(beginNans), in*2)];
        posEndNan = [xy{i,day}(logical(endNans), in*2-1), xy{i,day}(logical(endNans), in*2)];
        
        histPosNansTemp1 = histcounts2(posBeginNan(:, 2), posBeginNan(:, 1), edges{i,day}(1, :), edges{i,day}(2, :));
        histPosNansTemp2 = histcounts2(posEndNan(:, 2), posEndNan(:, 1), edges{i,day}(1, :), edges{i,day}(2, :));
        histPosNans{i,day}(in, :, :) = histPosNansTemp1 + histPosNansTemp2;
        % Remove unactive areas
%         histPosNans{i,day}(in, activeArea{i} == 0) = nan;
        
        %clear beginNans beginNansTemp endNans endNansTemp histPosNansTemp1 histPosNansTemp2 nanDurations posBeginNan posEndNan
    end
    sumHistPosNans{i,day}(:, :) = sum(histPosNans{i,day}(:, :, :));
    clear underThresh nans diffNans
    end
end
end
