clear all

parpool('local', 10)
inputsOldCombi

disp('load');
tic
load(parameters.filePath);
xy = xy(:, 22:32);
inNest = inNest(:, 22:32);
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
for in = 1:length(iterations)
    disp (['P(infect) = ' num2str(iterations(in))]);
    simTempNetworkCombi(contactsPerAnt, iterations(in), parameters.numOfReps, parameters.outputFolderPath);
end