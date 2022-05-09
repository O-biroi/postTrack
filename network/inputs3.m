parameters.time = datetime;

parameters.numOfFrames = 12000; % within segment
parameters.numOfSegments = 2;
parameters.filePath = '/shares/ulr-lab/users/daniel/GiacomoData/y';

parameters.withNest = 1;

parameters.contactThresh = 0.002;

parameters.infectionProbs = [0.001 0.101];
parameters.infectionProbsJumps = 0.05;
parameters.entryPoints = 2;
parameters.numOfReps = 2;

parameters.outputFolderPath = '/shares/ulr-lab/users/daniel/networks/output';
parameters.fileName = 'young.mat';
