function [] = checkNests(snapshotPath, nestBoundaries, edges, colonyInfo)
% snapshotPath - path to tiff image. Tiff image should be cropped to the
%   edges of the petri dish.
% nestBoundaries - should be of specific colony - nestBoundaries{i}
% edges - should be of specific colony - bins.edges{i}

snapshotObj = Tiff(snapshotPath, 'r');
snapshot = read(snapshotObj);
y = linspace(edges(1, 1), edges(1, end), size(snapshot, 1));
x = linspace(edges(2, 1), edges(2, end), size(snapshot, 2));
for i = 1:length(nestBoundaries)
    caption = [colonyInfo sprintf(' nest %d', i)];
    figure
    imagesc(x, y, snapshot(:,:,1:3));
    title(caption,'Fontsize',18);
    hold on
    plot(nestBoundaries{i}(1,:), nestBoundaries{i}(2, :));
    
end
