clear all

inputs2

disp('load');
tic
[xy, inNest] = load(parameters.filePath, parameters.variables);
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
iterations = parameters.infectionProbs(1):parameters.infectionProbsJumps:parameters.infectionProbs(end);
for in = iterations
    disp (['iteration ' num2str(i) ' out of ' num2str(length(iterations))]);
    simTempNetwork(contactsPerAnt, in, parameters.entryPoints, parameters.numOfReps, parameters.outputFolderPath);
end

clearvars i in
%
% disp(['saving as: ' fullfile(parameters.outputFolderPath, parameters.fileName)])
% save(fullfile(parameters.outputFolderPath, parameters.fileName), "infections", "parameters")