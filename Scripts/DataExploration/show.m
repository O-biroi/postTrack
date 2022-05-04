function show(xy)

close all

JET=jet(16);

% JET(1:8,:) = repmat([0, 0, 1], 8, 1);
% JET(9:16, :) = repmat([1, 0, 0], 8, 1);
figure;
xTemp = xy(:, 1:2:end);
yTemp = xy(:, 2:2:end);

minX = min(min(xTemp)) - 0.002;
minY = min(min(yTemp)) - 0.002;
maxX = max(max(xTemp)) + 0.002;
maxY = max(max(yTemp)) + 0.002;


x = xy(1, 1:2:end);
y = xy(1, 2:2:end);

h = scatter(x, y, 100, 'filled', 'MarkerFaceAlpha', 0.1);
ylim([minY maxY])
xlim([minX maxX])
hold on
for in = 2:size(xy, 1)
%     scatter(x, y, 100, 'w', 'filled');
%     scatter(x, y, 100, JET, 'filled', 'MarkerFaceAlpha', 0.1);
    x = xy(in, 1:2:end);
    y = xy(in, 2:2:end);
%     set('XData, x
%     h = scatter(x, y, 100, JET, 'filled');
%     h = scatter(x, y, 100, JET, 'filled');

    set(h, 'XData', x, 'YData', y)
    drawnow
    in
     pause(0.001);
end