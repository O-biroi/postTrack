clear all
parpool('local', 32)
parameters.inputFolder = '/shares/ulr-lab/Users/Daniel/outputs/outputY8';
parameters.time = datetime;
parameters.numOfFrames = 12000;
parameters.numOfFiles = 6;
parameters.numOfSegments = 32;
parameters.infectionProbs = [0.0005 0.001];
parameters.infectionProbsJumps = 0.0001;
parameters.entryPoints = 16;
parameters.numOfAnts = 16;
parameters.numOfReps = 100;

parameters.outputFolder = '/shares/ulr-lab/Users/Daniel/outputs/';
parameters.filename = 'Y8Array';



