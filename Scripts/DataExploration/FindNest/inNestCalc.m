function inNest = inNestCalc(xy, nestBoundaries)
inNest = cell(size(xy));
for i = 1:size(xy,1)
    for day = 1:size(xy,2)
    inNest{i,day} = NaN(size(xy{i,day}, 1), size(xy{i,day}, 2) / 2);
    for in = 1 : size(xy{i,day}, 2) / 2
        xyTemp = xy{i,day}(:, in * 2 - 1 : in * 2);
        xyTemp(isnan(xyTemp)) = -1;
        inNestTemp = [];
        if isempty(nestBoundaries{i,day}{1})
            continue
        end
        for ind = 1:length(nestBoundaries{i,day})
            inNestTemp(:, in, ind) = inpolygon(xyTemp(:, 1), xyTemp(:, 2), ...
                nestBoundaries{i,day}{ind}(1, :), nestBoundaries{i,day}{ind}(2, :));
            
        end
        inNestTemp = squeeze(sum(inNestTemp(:,:,:), 3));
        inNest{i,day}(:, in) = sum(inNestTemp, 2) > 0;
        clear xyTemp inNestTemp
    end
    end
end
end
