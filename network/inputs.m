parameters.numOfFrames = 6000; %12000*12*3;
parameters.numOfSegments = 2%12*3;
parameters.folderPath = '/shares/ulr-lab/users/daniel/GiacomoData/y';

parameters.withNest = 1;

parameters.contactThresh = 0.002;

parameters.infectionProbs = [0.001 0.1];
parameters.infectionProbsJumps = 0.5;%0.001;
parameters.entryPoints = 2;%1:16;
parameters.numOfReps = 2;%100;

parameters.outputFolderPath = '/shares/ulr-lab/users/daniel/networks/output';
parameters.fileName = 'young.mat';
