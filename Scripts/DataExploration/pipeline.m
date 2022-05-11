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

clear("splitNames");
%% Step 3. Calculate assignment rate, speed, in nest ratio by day
% Speed calculation
parameters.secondEachFrame = 0.1;
parameters.unit = "mm/s";
speedSplitByContinuousSegmentMaskInNest = calculateSpeed4XySplitted(xy2SplitByContinuousSegmentMaskInNest, parameters.numOfAnts, parameters.secondEachFrame, parameters.unit);
speedMergedMaskInNest = mergeSplittedXys(speedSplitByContinuousSegmentMaskInNest, parameters.numOfAnts, 1);
speedSplitByDayMaskInNest = splitMergedXys(speedMergedMaskInNest, parameters.framesPerDay - 12, 1); % only for calculating speed by day, cannot be used for matching frames with xy/inNest

% load experiment information
run("loadInfectionStatus.m"); 

% produce output table
outputAntTableMerged = makeOutputAntTable(xy2Merged, inNestWithNansMerged, speedMergedMaskInNest, parameters.numOfAnts, parameters.colonyID , parameters.antColour);
outputAntTableByDay = makeOutputAntTable(xy2SplitByDay, inNestWithNansSplitByDay, speedSplitByDayMaskInNest, parameters.numOfAnts, parameters.colonyID , parameters.antColour);
outputAntTableMergedJoined = join(outputAntTableMerged, antInfectionStatus);
outputAntTableByDayJoined = join(outputAntTableByDay, antInfectionStatus);

% save the data 
[filename, pathname] = uiputfile('*.csv');
writetable(outputAntTableMergedJoined, [pathname,filename]);
[filename, pathname] = uiputfile('*.csv');
writetable(outputAntTableByDayJoined, [pathname,filename]);

clear("filename","pathname");
%% Step 4: Plotting
v1 = figure;
violinplot(outputAntTableMergedJoined.OutNestRatio, outputAntTableMergedJoined.Treatment);
xticklabels({'Uninfected','Infected','Mix'})
xlabel("Colony Treatment")
ylabel("Ratio of time being outside the nest")
[filename, pathname] = uiputfile('*.svg');
saveas(v1, [pathname,filename], 'svg');

outputAntTableMergedJoined.ColonyTreatmentAntInfectionStatus = categorical(strcat(string(outputAntTableMergedJoined.Treatment), "_",string(outputAntTableMergedJoined.InfectionStatus)), ["C_uninfected", "T_infected", "X_uninfected", "X_infected"]);

% [#003f5c;#2f4b7c;#665191;#a05195,#d45087
% #f95d6a
% #ff7c43
% #ffa600]
% 
% 
% #00876c
% #3f9a70
% #66ac73
% #8bbe78
% #b1ce7e
% #d7df88
% #ffee95
% #fcd37b
% #f9b767
% #f49a59
% #ec7d51
% #e25e4f
% #d43d51


   colorVector =  [63, 154, 112;
    47 75 124;
    102 81 145;
    160 81 149]./ 255
v2 = figure;
violinplot(outputAntTableMergedJoined.OutNestRatio, outputAntTableMergedJoined.ColonyTreatmentAntInfectionStatus, 'ViolinColor', colorVector);
xticklabels({'Uninfected - uninfected','Infected - infected','Mix - uninfected', 'Mix - infected'})
xlabel("Colony Treatment - Ant Infection Status")
ylabel("Ratio of time being outside the nest")
[filename, pathname] = uiputfile('*.svg');
saveas(v2, [pathname,filename], 'svg');
