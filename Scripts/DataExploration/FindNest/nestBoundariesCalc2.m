function nestBoundaries = nestBoundariesCalc2(xy, nestArea, edges, edgesBin)

zeroMatrix = zeros(length(edges{1,1}) - 1);                                       % create empty variable
for i = 1:size(xy,1)
    for day = 1:size(xy,2)
        
    [~, nestCount] = groupcounts(nestArea{i,day}(:));                            % get the nests' numbers
    
    if length(nestCount) < 3                                                    % if there are less than 3 numbers in the image, there are no nests (0 - background, NaN - inactive arena area)
        nestBoundaries{i,day}{1} = [];                                              % insert an empty value
        continue                                                                % and go to the next video data
    end
    
    for in = 2:length(nestCount) - 1                                            % for each nest (starting from 2 to ignore 0s - background - and end before the last value - NaNs)
        nestAreaTemp = zeroMatrix;                                              % create empty matrix
        nestAreaTemp(nestArea{i,day} == nestCount(in)) = 1;                         % put 1s where the nest is
        nestBoundariesTemp = bwboundaries(nestAreaTemp);                        % find the nest boundaries. transpose the nest image so that the retrived indices of xy will fit with the row-col arrangment of the image.
        y = edges{i,day}(1, nestBoundariesTemp{1}(:, 1)) + 0.5 * edgesBin{i,day}(1);                         
        x = edges{i,day}(2, nestBoundariesTemp{1}(:, 2)) + 0.5 * edgesBin{i,day}(2);
        
        nestBoundaries{i,day}{nestCount(in)} = [x; y];
        clear nestBoundariesTemp row col x y
    end
    end
end

