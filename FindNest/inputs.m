clear all

%% Files configurations
parameters.folderPath ='/Users/lizimai/Insync/zimai.li@evobio.eu/Google Drive/DoctorToBe/01_Projects/ZIM01_Nematode/P2_Tracking/01_Data/cam5'; %Mac
%parameters.folderPath = 'C:\Users\galciato\polybox\Laptop\Age_Analysis\DeadPruned'; %Windows
parameters.numOfFiles = 6;
parameters.firstFile = 1;
parameters.numOfAnts = 8;
parameters.segment = 6000*24; % number of frames in one "day"

%% Define borders
parameters.activeThresh = 1 - pi/4; % prencentile: higher - narrower arena
parameters.numOfBinsHist = 100; % abs number: resolution of spatial distributions; higher - higher resolution


%% Deal with missing data
parameters.DurationThresh = 20; % prencentile: higher - more interpolation less nest
% parameters.prectileForNaNSpatialThresh = 95; % prencentile: more interpolation less nest

%% Nest area
% parameters.speedThresh = 20; % prencentile: higher - more nest area
parameters.nestThresh = 93;%0.4; % change between percentage and relative values in nestAreaCalc at line 14-15
parameters.smoothSigma = 2; % smooth gaussian std
parameters.minNestSize = 70; % minimal pixels of a nest - depends on numOfBinsHist %Originally 100

%% GA
%parameters.timelinePath = 'C:\Users\galciato\polybox\Laptop\Age_Analysis\TimeLine.txt'; %Windows
parameters.lastDay = 100; %last day 

