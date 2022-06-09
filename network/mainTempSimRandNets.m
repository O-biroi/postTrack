function mainTempSimRandNets(inputsFile)
parpool('local', 16)
eval(inputsFile)

load(parameters.filePath)

disp('contactRoutesCalc');
tic
contactsPerAnt = contactRoutesCalc(meetingsMatNew);
toc

disp('simTempNetwork');

iterations = parameters.infectionProbs(1):parameters.infectionProbsJumps:parameters.infectionProbs(end);
for in = 1:length(iterations)
    disp (['P(infect) = ' num2str(iterations(in))]);
    simTempNetwork(contactsPerAnt, iterations(in), parameters.entryPoints, parameters.numOfReps, parameters.outputFolderPath);
end