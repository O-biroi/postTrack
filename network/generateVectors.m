function generateVectors(inputsFileName)
    eval(inputsFileName)
    segmentLength = parameters.numOfFrames;
    iterations = parameters.infectionProbs(1):parameters.infectionProbsJumps:parameters.infectionProbs(end);
    infectionsVectors = zeros(length(iterations), parameters.numOfFiles, ...
        parameters.numOfSegments, parameters.entryPoints, ...
        parameters.numOfReps, segmentLength, "int8");
    i1 = 0;
    indeRange = 1:parameters.entryPoints;
    indexRange = 1:parameters.numOfReps;
    for i = iterations                                                      % for each infection probability
        i1 = i1+1;
        for in = 1:parameters.numOfFiles                                    % for each file
            parfor ind = 1:parameters.numOfSegments                         % for each segment
                for inde = indeRange                                        % for each entry point
                    for index = indexRange                                  % for each replication
                        fileName = (['infections_Prob' ...
                            num2str(i) 'File' num2str(in) ...
                            'Seg' num2str(ind) 'EP' ...
                            num2str(inde) 'Rep' num2str(index) '.mat']);
                        infectionsTemp = parload(parameters.inputFolder, fileName);
                        infectionsVectors(i1, in, ind, inde, index, :) = ... % make the vectors
                            makeVector(infectionsTemp.times, ...
                            segmentLength);
                    end
                end
            end
        end
    end
    save(fullfile(parameters.outputFolder, parameters.fileName), "infectionsVectors" );
end

function vector = makeVector(relevantTimesTemp, segmentLength)
    vector = zeros(1, segmentLength + 1);                                   % generate a vector of zeros as long as the segments
    relevantTimesTemp = relevantTimesTemp + 1;                              % add 1 to the infection times so the first won't be 0 but 1
    for i = 1:length(relevantTimesTemp) - 1
        vector(relevantTimesTemp(i):relevantTimesTemp(i+1) - 1) = i;        % fill the vector with the numbe of infected animals according to the infection times
    end
    vector(relevantTimesTemp(end):end) = length(relevantTimesTemp);         % fill the vector from last infection till end with the number of total infections
end

function loadedFile = parload(inputFolder, fileName)
    loadedFile = load(fullfile(inputFolder, fileName), "infectionsTemp");   % load the relevant infection times                                     
end