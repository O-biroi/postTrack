function inNestWithNans = copyNans(xy, inNest)
    inNestWithNans = inNest;
    for i = 1:size(xy, 1)
        for in = 1:size(xy, 2)
            xyTemp = xy{i, in}(:, 1:2:end);
            inNestWithNans{i, in}(isnan(xyTemp)) = nan;
        end
    end
end


