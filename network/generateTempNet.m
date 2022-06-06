function generateTempNet(genotype)
    load('/shares/ulr-lab/Users/Daniel/networks/contactsMat.mat')
    template = eval(genotype)
    numOfSteps = 12000;
    numOfNets2Produce = 10;

    parpool('local', numOfNets2Produce)

    numOfNodes = size(template{find(~cellfun(@isempty, template), 1, 'first')}, 1);
    emptyMat = zeros([numOfNodes, numOfNodes, numOfSteps], "logical");
    meetingsMat = cell(size(template, 1), size(template, 2), numOfNets2Produce);
    meetingsMat(cellfun(@isempty, meetingsMat)) = {emptyMat};
    % meetingsMat(cellfun(@isempty, template), :) = {nan};
    for i = 1:size(template, 1)
        for in = 1:size(template, 2)
            relvantTemp = template{i, in};
            if isempty(relvantTemp)
                meetingsMat(i, in, :) = {nan};
                continue
            end
            parfor ind = 1:numOfNets2Produce
                for inde = 2:numOfNodes
                    for index = 1:inde-1
                        randVec = randi(numOfSteps, relvantTemp(inde, index));
                        meetingsMat{i, in, ind}(inde, index, randVec) = 1;
                    end
                end
                disp([num2str(i) num2str(in), num2str(ind)]);
            end
        end
    end
    save(fullfile('/shares/ulr-lab/Users/Daniel/outputs/', append(genotype, 'RandomizedNetworks.mat')), "meetingsMat")
end