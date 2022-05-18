clear all

parpool('local', 8)
inputsLocalTest

disp('load');
tic
load(parameters.filePath);
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

iterations = parameters.infectionProbs(1):parameters.infectionProbsJumps:parameters.infectionProbs(end);
for in = iterations
    disp (['P(infect) = ' num2str(in)]);
    simTempNetwork(contactsPerAnt, in, parameters.entryPoints, parameters.numOfReps, parameters.outputFolderPath);
end


