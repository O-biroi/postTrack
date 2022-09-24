function [distancesMat] = calDistance(xy2, inNest, withNest)
    % withNest - either 1 or zero;
    %% prepare variables
    distancesMat = cell(size(xy2));                                         %   make an empty cell array
    for i = 1:1:size(xy2, 1)
        for in = 1:1:size(xy2, 2)
            xyTemp = xy2{i, in};                                            %   take XY coordinates of the current experiment and colony
            xTemp = xyTemp(:, 1:2:end);                                     %   seperate Xs and Ys
            yTemp = xyTemp(:, 2:2:end);
            inNestTemp = inNest{i, in};                                     %   take the inNest values for the current experiment and colony
            xTemp(logical(inNestTemp)) = nan;
            yTemp(logical(inNestTemp)) = nan;
            inNestTemp(inNestTemp == 0) = nan;                              % make all not in nest ants nans - for later calculation
            xSub = [];                                                      % make empty variables
            ySub = [];
            inNestSub = [];

            %%   distances calculation
            % take each column (animal), with all lines (frames),
            % and substract its coordinates from the other animals, one by
            % one. This reduces computation time, but creates a matrix
            % with non trivial order.

            for ind = 1:size(xTemp, 2)
                xSub = [xSub, nan(size(xTemp, 1), ind-1), xTemp(:, 1:end-ind+1) - xTemp(:, ind:end)];
                ySub = [ySub, nan(size(xTemp, 1), ind-1), yTemp(:, 1:end-ind+1) - yTemp(:, ind:end)];
                inNestSub = [inNestSub, nan(size(xTemp, 1), ind-1), inNestTemp(:, 1:end-ind+1) - inNestTemp(:, ind:end)];
            end

            distancesMatTemp1 = sqrt(xSub.^2 + ySub.^2);                    %   elucidian distance
            if withNest == 1
                distancesMatTemp1(inNestSub == 0) = 0;                      %   all inNest ants will have 0 distance from each other
            end

            %% make sense of the matrix order
            distancesMatTemp2 = reshape(distancesMatTemp1', ...
                size(inNestTemp, 2), size(inNestTemp, 2), []);              % organize the matrix into a n*n*num-of-frames matrix.
            for ind = 1:size(distancesMatTemp2, 1)
                distancesMatTemp2(ind, 1:ind, :) = ...
                    fliplr(distancesMatTemp2(ind, 1:ind, :));               % delete the upper half of the matrix
            end

            distancesMat{i, in} = distancesMatTemp2;                        % save distance mat
        end
    end
end




