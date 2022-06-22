clear all
parpool('local', 11)
parameters.inputFolder = '/shares/ulr-lab/Users/Daniel/outputs/outputCY3';
parameters.time = datetime;
parameters.numOfFrames = 12000;
parameters.numOfFiles = 6;
parameters.numOfSegments = 1:11;
parameters.infectionProbs = 0.0007;
parameters.infectionProbsJumps = 0.0001;
parameters.entryPoints = 20;
parameters.numOfAnts = 16;
parameters.numOfReps = 20;

parameters.outputFolder = '/shares/ulr-lab/Users/Daniel/outputs/';
parameters.filename = 'CY3Array';



