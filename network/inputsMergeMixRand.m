clear all
parpool('local', 11)
parameters.inputFolder = '/shares/ulr-lab/Users/Daniel/outputs/simMixRandomizedNetworks';
parameters.time = datetime;
parameters.numOfFrames = 12000;
parameters.numOfFiles = 40;
parameters.numOfSegments = 1:32;
parameters.infectionProbs = 0.0007;
parameters.infectionProbsJumps = 0.0001;
parameters.entryPoints = 16;
parameters.numOfAnts = 16;
parameters.numOfReps = 5;

parameters.outputFolder = '/shares/ulr-lab/Users/Daniel/outputs/';
parameters.filename = 'mixRand';



