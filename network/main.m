clear all

inputs

disp('loadFilesGiacomo');
tic
[xy, inNest] = loadFilesGiacomo(parameters.numOfFrames, parameters.numOfSegments, parameters.folderPath);
toc

disp('distancesClac');
tic
[distancesMat] = distancesClac(xy, inNest, parameters.withNest);
toc

disp('contactsCalc');
tic
contactsMat = contactsCalc(distancesMat, parameters.contactThresh);
toc

disp('contactRoutesCalc');
tic
contactsPerAnt = contactRoutesCalc(contactsMat);
toc

disp('simTempNetwork');
i = 0;
iterations
for in = parameters.infectionProbs(1):parameters.infectionProbsJumps:parameters.infectionProbs(end)
    i = i+1;
    disp (['iteration ' num2str(i) ' out of '])
    tic
    infections{i} = simTempNetwork(contactsPerAnt, in, parameters.entryPoints, parameters.numOfReps);
    toc
end

clearvars i in

disp(['saving as: ' fullfile(parameters.outputFolderPath, parameters.fileName)])
save(fullfile(parameters.outputFolderPath, parameters.fileName), "infections", "parameters")