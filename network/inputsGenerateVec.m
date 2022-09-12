clear all
parpool('local', 8)
parameters.inputFolder = '/Volumes/LaCie/data/Ulrich/tempNetSimulations/outputY3';
parameters.time = datetime;
parameters.numOfFrames = 12000;
parameters.numOfFiles = 6;
parameters.numOfSegments = 32;
parameters.infectionProbs = [0.001 0.101];
parameters.infectionProbsJumps = 0.01;
parameters.entryPoints = 16;
parameters.numOfReps = 20;

parameters.outputFolder = '/Users/daniel/Documents/Academia/Post-Ulrich/tests';
parameters.filename = 'Y3Mat';



