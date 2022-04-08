%% Read input parameters
inputs

%% Load files
%%Need to change this to keep also ant_info
[xy, names] = loadFiles(parameters.folderPath, parameters.firstFile, parameters.numOfFiles, parameters.segment, parameters.lastframe);

%% Spatial distribution
[histograms.spatialHist, bins.edges, bins.size, activeArea] = spatialHistCalc(xy, parameters.numOfBinsHist, parameters.activeThresh, parameters.arenaSize);

%% Calculate movement
% [speeds, histograms.standHist, histograms.runHist] = standRunCalc(xy, bins.edges, parameters.numOfBinsHist, parameters.speedThresh, activeArea);
nestArea = nestAreaCalc(activeArea, histograms.spatialHist, parameters.nestThresh, parameters.smoothSigma, parameters.minNestSize);
% nestArea2 = nestAreaStandRunCalc(activeArea, histograms.standHist, histograms.runHist, parameters.nestThresh, parameters.smoothSigma, parameters.minNestSize);
nestBoundaries = nestBoundariesCalc2(xy, nestArea, bins.edges, bins.size);
%Save nests
% save(fullfile(parameters.ExpDir,strcat('nestAreas',datestr(now, '_yy_mm_dd_HH_MM'))),'nestArea', 'nestBoundaries', 'bins', 'parameters','-v7.3');

%% Missing data
[histograms.nansHist, beginNansInd, endNansInd] = nansHist(xy, activeArea, bins.edges, parameters.numOfAnts);
[xy2, counter, nansToStart, nansRemoved] = dealWithNans4(xy, beginNansInd, endNansInd, nestBoundaries, parameters.DurationThresh);
inNest = inNestCalc(xy2, nestBoundaries);

%%Save results
% saveInterpolation(xy2, parameters.saveXY2, names, inNest, IDs, data);