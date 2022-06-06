function mainTempSimRandNets(inputsFile)
parpool('local', 32)
eval(inputsFile)

disp('contactRoutesCalc');
tic
contactsPerAnt = contactRoutesCalc(contactsMat);
toc

disp('simTempNetwork');

iterations = parameters.infectionProbs(1):parameters.infectionProbsJumps:parameters.infectionProbs(end);
for in = 1:length(iterations)
    disp (['P(infect) = ' num2str(iterations(in))]);
    simTempNetwork(contactsPerAnt, iterations(in), parameters.entryPoints, parameters.numOfReps, parameters.outputFolderPath);
end