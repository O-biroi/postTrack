function mergeFiles2Mat(inputsFileName)
    eval(inputsFileName)
    numOfAnts = parameters.numOfAnts;
    segments = parameters.numOfSegments;
    iterations = parameters.infectionProbs(1):parameters.infectionProbsJumps:parameters.infectionProbs(end);
    infectionsMat = nan(length(iterations), parameters.numOfFiles, ...
        length(segments), parameters.entryPoints, ...
        parameters.numOfReps, 3, numOfAnts, 'single');
    i1 = 0;
    indeRange = 1:parameters.entryPoints;
    indexRange = 1:parameters.numOfReps;
    inputFolder = parameters.inputFolder;
    for i = iterations                                                      % for each infection probability
        i1 = i1+1;
        for in = 1:parameters.numOfFiles                                    % for each file
            parfor ind = 1:length(segments)                         % for each segment
                seg = ind;
                disp(['prob ' num2str(i) 'file ' num2str(in) 'seg ' num2str(ind)])
                fileName = (['infections_Prob' ...
                    num2str(i) 'File' num2str(in) ...
                    'Seg' num2str(seg) '.mat']);
                infections = parload(inputFolder, fileName);
                infectionsMatTemp = nan(length(indeRange), length(indexRange), 3, numOfAnts);
                for inde = indeRange                                        % for each entry point
                    for index = indexRange                                  % for each replication
                        lenInf = length(infections(inde, index).infectedAnts);
                        infectionsMatTemp(inde, index, 1, 1:lenInf) = infections(inde, index).infectedAnts;
                        infectionsMatTemp(inde, index, 2, 1:lenInf) = infections(inde, index).infectingAnts;
                        infectionsMatTemp(inde, index, 3, 1:lenInf) = infections(inde, index).times;
                    end
                end
            infectionsMat(i1 ,in, ind, :, :, :, :) = infectionsMatTemp;
            end
        end
    end
    save(fullfile(parameters.outputFolder, parameters.filename), ...
        "infectionsMat", '-v7.3');
end

function vector = makeVector(relevantTimesTemp, segmentLength)
    vector = zeros(1, segmentLength + 1);                                   % generate a vector of zeros as long as the segments
    relevantTimesTemp = relevantTimesTemp + 1;                              % add 1 to the infection times so the first won't be 0 but 1
    for i = 1:length(relevantTimesTemp) - 1
        vector(relevantTimesTemp(i):relevantTimesTemp(i+1) - 1) = i;        % fill the vector with the numbe of infected animals according to the infection times
    end
    vector(relevantTimesTemp(end):end) = length(relevantTimesTemp);         % fill the vector from last infection till end with the number of total infections
end

function loadedVar = parload(inputFolder, fileName)
    load(fullfile(inputFolder, fileName), "infectionsTemp");                % load the relevant infection times
    loadedVar = infectionsTemp;
end