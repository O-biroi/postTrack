clear all
parpool('local', 32)
parameters.inputFolder = '/shares/ulr-lab/Users/Daniel/outputs/outputM5';
parameters.time = datetime;
parameters.numOfFrames = 12000;
parameters.numOfFiles = 5;
parameters.numOfSegments = 32;
parameters.infectionProbs = [0.001 0.101];
parameters.infectionProbsJumps = 0.01;
parameters.entryPoints = 16;
parameters.numOfReps = 20;

parameters.outputFolder = '/shares/ulr-lab/Users/Daniel/outputs/';
parameters.filename = 'M5Mat';



