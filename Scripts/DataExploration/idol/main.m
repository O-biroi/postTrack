clear;

%% Read input parameters
inputs;

%% Load files
[xy, names] = loadFiles(parameters.folderPath, parameters.firstFile, parameters.numOfFiles, parameters.lastframe);

%% Make Ant Table that includes calculated metrics for each individual
% preparation
[antTable] = makeTable(parameters.folderPath, parameters.numOfFiles, parameters.numOfAnts, parameters.antColours);
[nans] = countNans(xy, parameters.numOfFiles);

%% Basic metrics
% calculate metrics
[assignmentRate] = calAssignmentRate(nans, parameters.lastframe, parameters.numOfFiles);
[rmsd] = calRMSD(xy, nans, parameters.lastframe, parameters.numOfFiles, parameters.numOfAnts);

%% Network metrics
[inNest] = buildEmptyInNest(parameters.numOfFiles, parameters.numOfAnts, parameters.lastframe);
%%
[distancesMat]= calDistance(xy, inNest, 0);

%% Fill the antTable
% add metrics to table
[antTable] = addTableColumns(antTable, assignmentRate, "assignmentRate");
[antTable] = addTableColumns(antTable, rmsd, "rmsd");
[contactsMat] = calContacts(distancesMat, 0.001);

%%

%% Save Ant Table
[filename, pathname] = uiputfile('*.csv');
writetable(antTable, [pathname,filename]);