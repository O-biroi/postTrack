%% Complete pipeline for data exploration
% This is the main script for the data exploration steps of the tracking
% data

%% Step 1. Analysis setup and Find Nest
% Before this step
% 1. Make sure you are in the root folder of postTrack/Scripts/DataExploration
% 2. Edit the inputs.m file in the FindNest folder to setup the path of tracking results and parameters for the FindNest code

run("FindNest/main.m"); % run the main script for finding the nest, this may take long

[filename, pathname] = uiputfile('*.mat','Save Workspace Variables As'); % save workspace through ui
outputFindNest = fullfile(pathname, filename);
save(outputFindNest, "xy","xy2","inNestWithNansRaw","nestArea","parameters","names", '-v7.3');

clear("activeArea","outputFindNest","filename","pathname","nestBoundaries","nansToStart","nansRemoved","inNest","histograms","endNansInd","counter","bins","beginNansInd");
%% Step 2. Load and reshape experimental data and prepare the header of output tables
% If Step 1. was freshly run, ignore this step and move on
% Only run this step to load previous results from Step 1
clear;
load(uigetfile); % load Find Nest results from ui
parameters.framesPerDay = 144000;
parameters.framesPerContinuousSegment = 12000;
parameters.antColour = categorical(["BB","BG","BR","GG","GR","RB","RG","RR"]'); % colour code: sequence has to be matched with column sequence in the xy matrix
parameters.fileNames = names;
splitNames = split(string((sort(parameters.fileNames))'), ["_","."]);
parameters.colonyID = categorical(append(splitNames(:, 2),"_", splitNames(:, 3)));

% reshape the experimental data by cutting the segments of xy and xy2 with
% days
inNestWithNansMerged = mergeSplittedXys(inNestWithNansRaw, parameters.numOfAnts, 1);
inNestWithNansSplitByDay = splitMergedXys(inNestWithNansMerged, parameters.framesPerDay, 1);
inNestWithNansSplitByContinuousSegment = splitMergedXys(inNestWithNansMerged, parameters.framesPerContinuousSegment, 1);

xy2Merged = mergeSplittedXys(xy2, parameters.numOfAnts, 2);
xy2SplitByDay = splitMergedXys(xy2Merged, parameters.framesPerDay, 2);
xy2SplitByContinuousSegment = splitMergedXys(xy2Merged, parameters.framesPerContinuousSegment, 2);

xy2SplitByContinuousSegmentMaskInNest = maskInNest4XySplitted(xy2SplitByContinuousSegment, inNestWithNansSplitByContinuousSegment, 2, nan); % mask in nest frames for speed calculation

% create colony table with experiment information in the xy file names
outputColonyTable = table(string((sort(names))'),'VariableNames',{'Filename'});
splitNames = split(outputColonyTable.Filename, ["_","."]);
outputColonyTable.Treatment = categorical(splitNames(:, 2));
outputColonyTable.ColonyID = categorical(append(splitNames(:, 2),"_", splitNames(:, 3)));

% create ant table that will be nested in colony table
antTable = table(parameters.antColour, 'VariableNames',{'Colour'}); % create empty ant table for data storage of ants in each colony 

clear("splitNames");
%% Step 3. Calculate assignment rate, speed, in nest ratio by day
% Speed calculation
parameters.secondEachFrame = 0.1;
parameters.unit = "mm/s";
speedSplitByContinuousSegmentMaskInNest = calculateSpeed4XySplitted(xy2SplitByContinuousSegmentMaskInNest, parameters.numOfAnts, parameters.secondEachFrame, parameters.unit);
speedMergedMaskInNest = mergeSplittedXys(speedSplitByContinuousSegmentMaskInNest, parameters.numOfAnts, 1);
speedSplitByDayMaskInNest = splitMergedXys(speedMergedMaskInNest, parameters.framesPerDay - 12, 1); % only for calculating speed by day, cannot be used for matching frames with xy/inNest

% making output ant table
outputAntTable = makeOutputAntTable(xy2SplitByDay, inNestWithNansSplitByDay, speedSplitByDayMaskInNest, parameters.numOfAnts, parameters.colonyID , parameters.antColour);
run("loadInfectionStatus.m"); 


