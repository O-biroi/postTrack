% concantenate xy
xy_filtered = xy(:,1);
for i = 1:size(xy,1)
    for j = 2:size(xy,2)
    xy_filtered{i} = [xy_filtered{i};xy{i,j}];
    end
end

% get the index when most ants are not in the nest
num_inNest = sum(inNestWithNans{1,1},2);
index_mostNotInNest = find(num_inNest < 3);


% get the index when most ants share the same xy axis
x_filtered = xy_filtered{1,1}(:,1:2:15);
y_filtered = xy_filtered{1,1}(:,2:2:16);

for i = 1:size(x_filtered,1)
    [~,~,ix] = unique(x_filtered(i,:));
    x_duplicates(i) = max(accumarray(ix,1).');
end
index_xHighDuplicates = (find(x_duplicates > 6))';

for i = 1:size(y_filtered,1)
    [~,~,iy] = unique(y_filtered(i,:));
    y_duplicates(i) = max(accumarray(iy,1).');
end
index_yHighDuplicates = (find(y_duplicates > 6))';

index_tobemask = intersect(index_mostNotInNest, intersect(index_xHighDuplicates, index_yHighDuplicates));

inNestWithNansOriginal = inNestWithNans;
for i = index_tobemask
    inNestWithNans{1,1}(i,:)=NaN;
end

sum(inNestWithNansOriginal{1,1}, "all", "omitnan")/(length(inNestWithNansOriginal{1,1})*8 - sum(sum(isnan(inNestWithNansOriginal{1,1}))));
sum(inNestWithNans{1,1}, "all", "omitnan")/(length(inNestWithNans{1,1})*8 - sum(sum(isnan(inNestWithNans{1,1}))));
1-sum(sum(isnan(inNestWithNans{1,1})/(length(inNestWithNans{1,1})*8)));