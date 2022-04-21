clear all

framesToDivide = 6000;
numOfDivs = 1;
folderPath = '/Users/daniel/Desktop/nosync.nosync/Nest_Interpolation/y';
% for i = 1:size(antMeans, 1)
% subplot(6,2,i*2-1)
% heatmap(squeeze(antMeans(i,:,:)))
% subplot(6,2,i*2)
% heatmap(squeeze(antVars(i,:,:)))
% end
% colormap(jet)


files = dir(fullfile(folderPath,'*.mat'));
for i = 1:length(files)
    varNames = {'ant_xy', 'ant_nest'};
    load(fullfile(files(i).folder, files(i).name), varNames{:});
    for in = 1:numOfDivs
        xy{i, in} = ant_xy((in-1)*framesToDivide+1:in*framesToDivide, :);
        inNest{i, in} = ant_nest((in-1)*framesToDivide+1:in*framesToDivide, :);
    end
end
clearvars -except xy inNest
    
