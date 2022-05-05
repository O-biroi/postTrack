function [xy2, counter, nansToStart, nansRemoved] = dealWithNans4(xy, beginNansInd, endNansInd, nestBoundaries, NaNDurationThresh, aaa)

xy2 = xy;
counter = cell(size(xy));

for i = 1:size(xy,1)
    
    for day = 1:sum((~cellfun(@isempty,xy(i,:))))
    %% Calculate the durations & positions of the unrecognized sequences
    % Find unrecognized frames
    
    counter{i,day} = cell(1, size(xy{i,day}, 2) / 2);
    
    for in = 1:size(xy{i,day}, 2) / 2
        xyTemp = xy{i,day}(:, in*2-1 : in*2);
        nansToRemove = [];
        nanDurations = endNansInd{i,day, in} - beginNansInd{i,day, in};
        nansToStart{i,day}{in} = xyTemp(beginNansInd{i,day, in}, :);
        nansAtEnd{i,day}{in} = nansToStart{i,day}{in};
        nans2interp = find(nanDurations < NaNDurationThresh); %find missing data with short 
        counterTemp1 = [];
        counterTemp2 = [];
        counterTemp3 = [];
        counterTemp4 = [];
        for ind = 1:length(nans2interp)
            xInterp = linspace(xy{i,day}(beginNansInd{i,day,in}(nans2interp(ind)), in*2-1), xy{i,day}(endNansInd{i,day,in}(nans2interp(ind)), in*2-1), nanDurations(nans2interp(ind)) + 1);
            yInterp = linspace(xy{i,day}(beginNansInd{i,day,in}(nans2interp(ind)), in*2), xy{i,day}(endNansInd{i,day,in}(nans2interp(ind)), in*2), nanDurations(nans2interp(ind)) + 1);
            xyTemp(beginNansInd{i,day,in}(nans2interp(ind)) : endNansInd{i,day,in}(nans2interp(ind)), 1:2) = [xInterp', yInterp'];
            counterTemp1 = [counterTemp1, 1];
            counterTemp2 = [counterTemp2, endNansInd{i,day,in}(nans2interp(ind)) - beginNansInd{i,day,in}(nans2interp(ind))];
            counterTemp3 = [counterTemp3, xy{i,day}(beginNansInd{i,day,in}(nans2interp(ind)), in*2-1)];
            counterTemp4 = [counterTemp4, xy{i,day}(beginNansInd{i,day,in}(nans2interp(ind)), in*2)]; 
            
            nansToRemove = [nansToRemove, beginNansInd{i,day,in}(nans2interp(ind))];
            clear xInterp yInterp
        end
        
        if isempty(nestBoundaries{i,day})
            continue
        end
        
        for ind = 1:length(beginNansInd{i,day,in})
%             if ismember(xy{i}(beginNansInd{i,in}(ind), in*2-1:in*2), a, 'rows')
%                 1
%             end
            if sum(ismember(beginNansInd{i,day,in}(ind), nansToRemove)) == 1
                continue
            end
            if isempty(nestBoundaries{i,day}{1}) %%GA:Some values are empty, 
                continue
            end   
            for inde = 1:length(nestBoundaries{i,day})
                if isempty(endNansInd{i, day, in})
                continue
                end
                a = inpolygon(xy{i,day}(beginNansInd{i,day,in}(ind), in*2-1), ...
                     xy{i,day}(beginNansInd{i,day,in}(ind), in*2), ...
                     nestBoundaries{i,day}{inde}(1, :), ...
                     nestBoundaries{i,day}{inde}(2, :));
                 b = inpolygon(xy{i,day}(endNansInd{i,day,in}(ind), in*2-1), ...
                     xy{i,day}(endNansInd{i,day,in}(ind), in*2), ...
                     nestBoundaries{i,day}{inde}(1, :), ...
                     nestBoundaries{i,day}{inde}(2, :));
                 [interX, interY] = polyxpoly([xy{i,day}(beginNansInd{i,day,in}(ind), in*2-1), ...
                     xy{i,day}(endNansInd{i,day,in}(ind), in*2-1)],[xy{i,day}(beginNansInd{i,day,in}(ind), in*2), ...
                     xy{i,day}(endNansInd{i,day,in}(ind), in*2)], nestBoundaries{i,day}{inde}(1, :), ...
                     nestBoundaries{i,day}{inde}(2, :)); 
                 c = ~isempty(interX);
                
                if a && ~b
                    newXY = xy{i,day}(beginNansInd{i,day,in}(ind), in*2-1:in*2);
                elseif a && b
                    newXY = (xy{i,day}(beginNansInd{i,day,in}(ind), in*2-1:in*2) + ...
                        xy{i,day}(endNansInd{i,day,in}(ind), in*2-1:in*2)) ./ 2;
                elseif b
                    newXY = xy{i,day}(endNansInd{i,day,in}(ind), in*2-1:in*2);
                elseif c
                    if length(interX) == 1
                        continue
                    end
                    newXY = [interX(1), interY(1)] + [interX(2), interY(2)] ./2;
                end
                    
                if any([a, b, c])
                    xyTemp(beginNansInd{i,day,in}(ind) + 1 : endNansInd{i,day,in}(ind) - 1, 1) = newXY(1);
                    xyTemp(beginNansInd{i,day,in}(ind) + 1 : endNansInd{i,day,in}(ind) - 1, 2) = newXY(2);
                    
                    counterTemp1 = [counterTemp1, 2];
                    counterTemp2 = [counterTemp2, endNansInd{i,day,in}(ind) - beginNansInd{i,day,in}(ind)];
                    counterTemp3 = [counterTemp3, xyTemp(beginNansInd{i,day,in}(ind), 1)];
                    counterTemp4 = [counterTemp4, xyTemp(beginNansInd{i,day,in}(ind), 2)];
                    
                    nansToRemove = [nansToRemove, beginNansInd{i,day,in}(ind)];
                end
                
                
                clear interX interY newXY a b c
            end
        end
        
        nansRemoved{i,day}{in} = xyTemp(nansToRemove, :);
        xy2{i,day}(:, in * 2 - 1 : in * 2) = xyTemp;
        counter{i,day}{in} = [counterTemp1; counterTemp2; counterTemp3; counterTemp4];
        
        clearvars -except day aaa xy xy2 NaNDurationThresh counter i nestBoundaries endNansInd beginNansInd nansAtEnd nansToStart nansToRemove nansRemoved

    end
    end
end
      
end
        
        