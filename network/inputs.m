parameters.numOfFrames = %12000*12*3;
parameters.numOfSegments = %12*3;
parameters.folderPath = '/shares/ulr-lab/users/daniel/GiacomoData/y';

parameters.withNest = 1;

parameters.contactThresh = 0.002;

parameters.infectionProbs = [0.001 0.1];
parameters.infectionProbsJumps = 0.5;%0.001;
parameters.entryPoints = 1;%1:16;
parameters.numOfReps = 1;%100;

parameters.outputFolderPath = '/shares/ulr-lab/users/daniel/networks/output';
parameters.fileName = 'young.mat';
