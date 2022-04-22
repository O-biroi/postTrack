function infectionsVectors = generateVectors(parameters, infections)
    segmentLength = parameters.numOfFrames/parameters.numOfSegments;

    for i = 1:length(infections)                                            % for each infection probability
        for in = 1:size(infections{i}, 1)                                   % for each file
            for ind = 1:size(infections{i}, 2)                              % for each segment
                for inde = 1:size(infections{i}, 3)                         % for each entry point
                    for index = 1:size(infections{i}, 4)                    % for each replication
                        relevantTimesTemp = ...                                 
                            infections{i}{in, ind, inde, index}.times;      % extract the relevant infection times
                        infectionsVectors{i}{in, ind, inde, index} = ...    % make the vector
                            makeVector(relevantTimesTemp, segmentLength);
                    end
                end
            end
        end
    end
end

function vector = makeVector(relevantTimesTemp, segmentLength)
    vector = zeros(1, segmentLength + 1);                                   % generate a vector of zeros as long as the segments
    relevantTimesTemp = relevantTimesTemp + 1;                              % add 1 to the infection times so the first won't be 0 but 1
    for i = 1:length(relevantTimesTemp) - 1
        vector(relevantTimesTemp(i):relevantTimesTemp(i+1) - 1) = i;        % fill the vector with the numbe of infected animals according to the infection times
    end
    vector(relevantTimesTemp(end):end) = length(relevantTimesTemp);         % fill the vector from last infection till end with the number of total infections
end


