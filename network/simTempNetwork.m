numOfAnts = 16;
entryPoints = linspace(1, numOfAnts, numOfAnts);
numOfReps = 10;
infectionProb = 0.01;

for i = 1:size(contactsPerAnt, 1)
    for in = 1:size(contactsPerAnt, 2)
        for ind = 1:length(entryPoints)
            infectedAnts = ind;
            infectedContacts = contactsPerAnt{i, in, ind};
            for inde = 1:numOfReps
                infectionTimes{i, in, ind, inde} = 0;
                index = 1;
                while index <= size(infectedContacts, 1) && length(infectedAnts) ~= numOfAnts
                    if rand < infectionProb
                        if ~ismember(infectedContacts(index, 2), infectedAnts)
                            infectedAnts = [infectedAnts, infectedContacts(index, 2)];
                            infectionTimes{i, in, ind, inde} = [infectionTimes{i, in, ind, inde}, infectedContacts(index, 1)];
                            infectedContactsTemp = contactsPerAnt{i, in, infectedContacts(index, 2)};
                            infectedContactsTemp(infectedContactsTemp(:, 1) < infectedContacts(index, 1), :) = [];
                            infectedContacts = [infectedContacts; contactsPerAnt{i, in, infectedContacts(index, 2)}];
                            infectedContacts = sortrows(infectedContacts);
                            clearvars infectedContactsTemp
                        end
                    end
                    index = index+1;
                end
            end
        end
    end
end

