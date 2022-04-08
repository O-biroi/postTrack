clear all

%% Files configurations
parameters.folderPath ='/Users/lizimai/Insync/zimai.li@evobio.eu/Google Drive/DoctorToBe/01_Projects/ZIM01_Nematode/P2_Tracking/01_Data/cam5'; % Macbook Pro Zimai
%parameters.folderPath ='/Users/zli/Insync/zimai.li@evobio.eu/Google Drive/DoctorToBe/01_Projects/ZIM01_Nematode/P2_Tracking/01_Data/cam5'; % iMac Office
%parameters.folderPath = 'C:\Users\galciato\polybox\Laptop\Age_Analysis\DeadPruned'; %Windows
parameters.numOfFiles = 4; % the last file 
parameters.firstFile = 1;   
parameters.numOfAnts = 8;
parameters.arenaSize = 0.05; % size of circular arena (in meters)
parameters.lastframe = 864000; % the last frame to be included in the analysis
parameters.segment = 6000*24; % number of frames in one "day"

%% Define borders
parameters.activeThresh = 1 - pi/4; % prencentile: higher - narrower arena
parameters.numOfBinsHist = 80; % abs number: resolution of spatial distributions; higher - higher resolution


%% Deal with missing data
parameters.DurationThresh = 20; % prencentile: higher - more interpolation less nest
% parameters.prectileForNaNSpatialThresh = 95; % prencentile: more interpolation less nest

%% Nest area
% parameters.speedThresh = 20; % prencentile: higher - more nest area
parameters.nestThresh = 92;%0.4; % change between percentage and relative values in nestAreaCalc at line 14-15
parameters.smoothSigma = 3; % smooth gaussian std
parameters.minNestSize = 70; % minimal pixels of a nest - depends on numOfBinsHist %Originally 100

%% GA
%parameters.timelinePath = 'C:\Users\galciato\polybox\Laptop\Age_Analysis\TimeLine.txt'; %Windows
parameters.lastDay = 100; %last day 

