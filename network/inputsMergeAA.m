clear all
parpool('local', 32)
parameters.inputFolder = '/shares/ulr-lab/Users/Daniel/outputs/outputAA2';
parameters.time = datetime;
parameters.numOfFrames = 12000;
parameters.numOfFiles = 8;
parameters.numOfSegments = 32;
parameters.infectionProbs = [0.0005 0.001];
parameters.infectionProbsJumps = 0.0001;
parameters.entryPoints = 8;
parameters.numOfAnts = 8;
parameters.numOfReps = 100;

parameters.outputFolder = '/shares/ulr-lab/Users/Daniel/outputs/';
parameters.filename = 'AA2Mat';



